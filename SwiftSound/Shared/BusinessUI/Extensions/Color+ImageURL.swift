//
//  Color+imageURL.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/25.
//

import AppKit
import Kingfisher
import SwiftUI

extension Color {
    static func themeColor(from imageURLString: String) async -> Color? {
        return await themeColor(from: URL(string: imageURLString))
    }

    static func themeColor(from imageURL: URL?) async -> Color? {
        guard let imageURL else { return nil }

        return await ImageThemeColorProvider.shared.color(from: imageURL.httpsURL)
    }
}

// MARK: - ImageThemeColorProvider
private actor ImageThemeColorProvider {
    static let shared = ImageThemeColorProvider()

    private var cache: [URL: Color] = [:]

    func color(from imageURL: URL) async -> Color? {
        if let color = cache[imageURL] {
            return color
        }

        guard let image = await Self.retrieveImage(for: imageURL),
              let color = Self.extractThemeColor(from: image) else {
            return nil
        }

        cache[imageURL] = color
        return color
    }
}

private extension ImageThemeColorProvider {
    static func retrieveImage(for url: URL) async -> NSImage? {
        await withCheckedContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case let .success(value):
                    continuation.resume(returning: value.image)
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    static func extractThemeColor(from image: NSImage) -> Color? {
        guard let samples = themeColorSamples(from: image) else { return nil }

        let selectedSample = samples.reduce(into: SampleSelection()) { selection, sample in
            selection.include(sample)
        }
        .selectedSample

        return selectedSample.map { sample in
            Color(red: sample.adjustedRed, green: sample.adjustedGreen, blue: sample.adjustedBlue)
        }
    }
}

private nonisolated func themeColorSamples(from image: NSImage) -> [ThemeColorSample]? {
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        return nil
    }

    guard cgImage.width > 0, cgImage.height > 0 else { return nil }

    let width = ThemeColorSampling.sampleSize
    let height = ThemeColorSampling.sampleSize
    var pixelData = [UInt8](repeating: 0, count: width * height * 4)
    let bytesPerRow = width * 4

    let didDraw = pixelData.withUnsafeMutableBytes { buffer in
        guard let baseAddress = buffer.baseAddress,
              let context = CGContext(
                data: baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              ) else {
            return false
        }

        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return true
    }

    guard didDraw else { return nil }

    return stride(from: 0, to: pixelData.count, by: 4).compactMap { offset in
        let pixelIndex = offset / 4
        let y = pixelIndex / width
        let normalizedY = Double(y) / Double(max(height - 1, 1))

        return ThemeColorSample(
            red: Double(pixelData[offset]) / 255,
            green: Double(pixelData[offset + 1]) / 255,
            blue: Double(pixelData[offset + 2]) / 255,
            alpha: Double(pixelData[offset + 3]) / 255,
            spatialWeight: ThemeColorSampling.spatialWeight(forNormalizedY: normalizedY)
        )
    }
}

private enum ThemeColorSampling {
    nonisolated static let sampleSize = 48
    nonisolated static let minimumAlpha = 0.1
    nonisolated static let minimumBrightness = 0.03
    nonisolated static let lowSaturationThreshold = 0.18
    nonisolated static let shadowNeutralMinimumCoverage = 0.16
    nonisolated static let shadowNeutralDominanceRatio = 1.12
    nonisolated static let dominantBackgroundMinimumCoverage = 0.35
    nonisolated static let dominantBackgroundDominanceRatio = 2.2

    private nonisolated static let bottomRegionBaseWeight = 0.65
    private nonisolated static let bottomRegionExtraWeight = 0.85

    nonisolated static func spatialWeight(forNormalizedY normalizedY: Double) -> Double {
        bottomRegionBaseWeight + pow(normalizedY, 2) * bottomRegionExtraWeight
    }
}

private struct ThemeColorSample {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    let spatialWeight: Double

    nonisolated var brightness: Double {
        max(red, green, blue)
    }

    nonisolated var saturation: Double {
        let maximum = max(red, green, blue)
        guard maximum > 0 else { return 0 }

        return (maximum - min(red, green, blue)) / maximum
    }

    nonisolated var quantizedKey: Int {
        // 低饱和颜色主要靠明度区分。灰、黑、白如果按 RGB 分桶会被拆得太碎，
        // 很容易输给小面积的高饱和装饰色，所以这里单独按明度聚合。
        if saturation < ThemeColorSampling.lowSaturationThreshold {
            let brightnessBucket = min(5, max(0, Int((brightness * 6).rounded(.down))))
            return 10_000 + brightnessBucket
        }

        // 有明显色相的颜色按 HSV 粗分桶。Hue 决定色系，saturation/brightness
        // 决定同一色系里的深浅和纯度，结果会比直接 RGB 量化更符合视觉感知。
        let hueBucket = min(23, max(0, Int((hue * 24).rounded(.down))))
        let saturationBucket = min(3, max(0, Int(((saturation - 0.18) / 0.82 * 4).rounded(.down))))
        let brightnessBucket = min(4, max(0, Int((brightness * 5).rounded(.down))))

        // 红/橙/棕经常同时出现在肤色、头发和暖色遮罩里。按亮度拆桶会把同一主题色
        // 切得过碎，反而输给大面积低饱和背景色，所以暖色只按色相和饱和度聚合。
        if hue < 0.12 || hue > 0.92 {
            return 20_000 + (hueBucket << 4) + saturationBucket
        }

        return hueBucket << 8 | saturationBucket << 4 | brightnessBucket
    }

    nonisolated var hue: Double {
        let maximum = max(red, green, blue)
        let minimum = min(red, green, blue)
        let delta = maximum - minimum
        guard delta > 0 else { return 0 }

        let rawHue: Double
        if maximum == red {
            rawHue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
        } else if maximum == green {
            rawHue = ((blue - red) / delta) + 2
        } else {
            rawHue = ((red - green) / delta) + 4
        }

        let normalizedHue = rawHue / 6
        return normalizedHue < 0 ? normalizedHue + 1 : normalizedHue
    }

    nonisolated var score: Double {
        // 主题色用于封面底部面板，不适合取封面里最刺眼的小色块。
        // 因此：过亮/近白降权；极暗小块降权；饱和色保留优势但不过度放大。
        let lightPenalty = brightness > 0.88 ? 0.22 : (brightness > 0.72 ? 0.62 : 1)
        let whitePenalty = saturation < 0.12 && brightness > 0.7 ? 0.35 : 1
        let saturationWeight = 0.85 + min(saturation, 0.65) * 0.45
        let brightnessTarget = saturation > 0.45 ? 0.38 : 0.56
        let brightnessWeight = max(0.35, 1 - min(abs(brightness - brightnessTarget), 0.7) * 0.9)
        let lowBrightnessPenalty = brightness < 0.18 ? 0.42 : 1
        let mutedTintPenalty = saturation < 0.16 && brightness > 0.45 ? 0.42 : 1
        let isCoolMutedOverlay = hue > 0.40 && hue < 0.58 && saturation < 0.34 && brightness > 0.30
        let isWarmHighlight = (hue < 0.12 || hue > 0.92) && brightness > 0.62
        let coolMutedOverlayPenalty = isCoolMutedOverlay ? 0.28 : 1
        let warmHighlightPenalty = isWarmHighlight ? 0.72 : 1

        return saturationWeight
            * brightnessWeight
            * lightPenalty
            * whitePenalty
            * lowBrightnessPenalty
            * mutedTintPenalty
            * coolMutedOverlayPenalty
            * warmHighlightPenalty
            * spatialWeight
    }

    nonisolated var isShadowNeutralCandidate: Bool {
        // 大面积深灰/暗中性色通常是封面背景色。即使饱和度低，也应该优先作为 UI 主题色，
        // 例如黑灰封面不能被一小块红色文字或水印抢走。
        saturation < 0.22
            && brightness >= 0.08
            && brightness <= 0.45
    }

    nonisolated var isDominantBackgroundCandidate: Bool {
        // 大面积米色/蓝灰背景比人物肤色、头发或文案色更适合作为面板底色。
        // 但青绿色低饱和遮罩容易误伤 case 2，所以这里排除 cyan 区间。
        saturation < 0.18
            && brightness >= 0.5
            && brightness <= 0.93
            && (hue < 0.22 || hue > 0.58)
    }

    nonisolated var adjustedRed: Double {
        adjustedComponents.red
    }

    nonisolated var adjustedGreen: Double {
        adjustedComponents.green
    }

    nonisolated var adjustedBlue: Double {
        adjustedComponents.blue
    }

    // swiftlint:disable large_tuple
    private nonisolated var adjustedComponents: (red: Double, green: Double, blue: Double) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        NSColor(
            calibratedRed: red,
            green: green,
            blue: blue,
            alpha: self.alpha
        )
        .getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        // 输出给渐变面板时做轻量归一化：太亮会压不住白字，太暗会丢失封面色相。
        // 高饱和色上限更低，避免红/橙/蓝等颜色显得过亮。
        let maximumBrightness: CGFloat = saturation > 0.55 ? 0.59 : 0.69
        let adjustedSaturation = saturation.clamped(to: 0.16...0.86)
        let adjustedBrightness = brightness.clamped(to: 0.18...maximumBrightness)
        let color = NSColor(
            calibratedHue: hue,
            saturation: adjustedSaturation,
            brightness: adjustedBrightness,
            alpha: 1
        )

        return (
            Double(color.redComponent),
            Double(color.greenComponent),
            Double(color.blueComponent)
        )
    }
    // swiftlint:enable large_tuple
}

private struct SampleSelection {
    private var colorBuckets: [Int: ThemeColorBucket] = [:]
    private var fallbackBucket = ThemeColorBucket()
    private var shadowNeutralBucket = ThemeColorBucket()
    private var dominantBackgroundBucket = ThemeColorBucket()
    private var sampleCount = 0

    nonisolated init() {}

    nonisolated var selectedSample: ThemeColorSample? {
        let leadingBucket = colorBuckets.values.max(by: { $0.weightedScore < $1.weightedScore })

        if dominantBackgroundBucket.coverage(in: sampleCount) >= ThemeColorSampling.dominantBackgroundMinimumCoverage,
           dominantBackgroundBucket.coverage(in: sampleCount) > (leadingBucket?.coverage(in: sampleCount) ?? 0)
                * ThemeColorSampling.dominantBackgroundDominanceRatio {
            return dominantBackgroundBucket.averageSample
        }

        // 如果暗中性色覆盖明显更大，优先返回它；否则选择综合覆盖率和视觉权重最高的分桶。
        if shadowNeutralBucket.coverage(in: sampleCount) >= ThemeColorSampling.shadowNeutralMinimumCoverage,
           shadowNeutralBucket.coverage(in: sampleCount) > (leadingBucket?.coverage(in: sampleCount) ?? 0)
                * ThemeColorSampling.shadowNeutralDominanceRatio {
            return shadowNeutralBucket.averageSample
        }

        return leadingBucket?.averageSample ?? fallbackBucket.averageSample
    }

    nonisolated mutating func include(_ sample: ThemeColorSample) {
        guard sample.alpha >= ThemeColorSampling.minimumAlpha,
              sample.brightness > ThemeColorSampling.minimumBrightness else {
            return
        }

        sampleCount += 1
        fallbackBucket.include(sample)

        if sample.isShadowNeutralCandidate {
            shadowNeutralBucket.include(sample)
        }

        if sample.isDominantBackgroundCandidate {
            dominantBackgroundBucket.include(sample)
        }

        colorBuckets[sample.quantizedKey, default: ThemeColorBucket()].include(sample)
    }
}

private struct ThemeColorBucket {
    private var totalRed = 0.0
    private var totalGreen = 0.0
    private var totalBlue = 0.0
    private var totalAlpha = 0.0
    private var totalScore = 0.0
    private var sampleCount = 0

    nonisolated init() {}

    nonisolated var weightedScore: Double {
        pow(Double(sampleCount), 0.82) * totalScore / max(Double(sampleCount), 1)
    }

    nonisolated var averageSample: ThemeColorSample? {
        guard sampleCount != 0 else { return nil }

        return ThemeColorSample(
            red: totalRed / Double(sampleCount),
            green: totalGreen / Double(sampleCount),
            blue: totalBlue / Double(sampleCount),
            alpha: totalAlpha / Double(sampleCount),
            spatialWeight: 1
        )
    }

    nonisolated mutating func include(_ sample: ThemeColorSample) {
        totalRed += sample.red
        totalGreen += sample.green
        totalBlue += sample.blue
        totalAlpha += sample.alpha
        totalScore += sample.score
        sampleCount += 1
    }

    nonisolated func coverage(in totalCount: Int) -> Double {
        guard totalCount > 0 else { return 0 }

        return Double(sampleCount) / Double(totalCount)
    }
}

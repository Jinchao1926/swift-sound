//
//  PlayerMarqueeText.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct PlayerMarqueeText: View {
    let text: String
    let font: Font
    let fontWeight: Font.Weight?
    let foregroundColor: Color
    let maxWidth: CGFloat

    @State private var contentWidth: CGFloat = 0
    @State private var offset: CGFloat = 0

    init(
        _ text: String,
        font: Font = .font16,
        fontWeight: Font.Weight? = .semibold,
        foregroundColor: Color = .textPrimary,
        maxWidth: CGFloat
    ) {
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
        self.foregroundColor = foregroundColor
        self.maxWidth = maxWidth
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if shouldScroll {
                HStack(spacing: Layout.repeatSpacing) {
                    // 两份文本是为了循环滚动时不断档，看起来像连续滚动
                    marqueeText
                    marqueeText
                }
                .offset(x: offset)
            } else {
                marqueeText
            }
        }
        .frame(width: displayWidth, alignment: .leading)
        .clipped()
        .onPreferenceChange(PlayerTextWidthPreferenceKey.self) { width in
            // 测量文本宽度
            contentWidth = width
            restartAnimationIfNeeded()
        }
        .onChange(of: text) { _, _ in
            offset = 0
            restartAnimationIfNeeded()
        }
    }

    private var marqueeText: some View {
        Text(text)
            .font(font)
            .fontWeight(fontWeight)
            .foregroundStyle(foregroundColor)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: PlayerTextWidthPreferenceKey.self, value: proxy.size.width)
                }
            )
    }

    private var shouldScroll: Bool {
        contentWidth > maxWidth
    }

    private var displayWidth: CGFloat? {
        guard contentWidth > 0 else { return nil }
        return min(contentWidth, maxWidth)
    }

    private var animationDistance: CGFloat {
        contentWidth + Layout.repeatSpacing
    }

    private var animationDuration: TimeInterval {
        max(TimeInterval(animationDistance / Layout.pointsPerSecond), Layout.minimumDuration)
    }

    private func restartAnimationIfNeeded() {
        guard shouldScroll else {
            offset = 0
            return
        }

        offset = 0
        DispatchQueue.main.async {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                offset = -animationDistance
            }
        }
    }

    private enum Layout {
        static let repeatSpacing: CGFloat = 24
        static let pointsPerSecond: CGFloat = 30
        static let minimumDuration: TimeInterval = 5.0
    }
}

private struct PlayerTextWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    VStack(alignment: .leading) {
        PlayerMarqueeText(
            "这是一首很长很长的歌曲标题用来预览播放器标题滚动",
            maxWidth: 180
        )

        PlayerMarqueeText(
            "歌曲标题",
            maxWidth: 180
        )
    }
    .padding()
}

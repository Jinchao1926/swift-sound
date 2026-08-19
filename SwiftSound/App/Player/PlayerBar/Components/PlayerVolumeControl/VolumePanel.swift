//
//  VolumePanel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/6.
//

import SwiftUI

// MARK: - VolumePanel
struct VolumePanel: View {
    let volume: Double
    let isMuted: Bool
    let onSetVolume: (Double) -> Void
    let onEditingChanged: (Bool) -> Void

    @Environment(\.playerBarStyle) private var style

    var body: some View {
        VStack(spacing: VolumePanelLayout.panelSpacing) {
            VerticalVolumeSlider(
                value: volumeBinding,
                onEditingChanged: onEditingChanged
            )
            .frame(width: VolumePanelLayout.panelWidth, height: VolumePanelLayout.sliderLength)

            Text(volumeText)
                .font(.font12)
                .foregroundStyle(style.secondaryTextColor)
                .monospacedDigit()
        }
        .frame(width: VolumePanelLayout.panelWidth, height: VolumePanelLayout.panelHeight)
        .padding(.top, VolumePanelLayout.shadowTopInset)
        .frame(
            width: VolumePanelLayout.contentSize.width,
            height: VolumePanelLayout.contentSize.height,
            alignment: .top
        )
    }

    // MARK: Private
    private var effectiveVolume: Double {
        isMuted ? 0 : volume
    }

    private var volumeBinding: Binding<Double> {
        Binding(
            get: {
                effectiveVolume
            },
            set: {
                onSetVolume($0.clamped(to: 0...1))
            }
        )
    }

    private var volumeText: String {
        "\(Int((effectiveVolume * 100).rounded()))%"
    }
}

// MARK: - VerticalVolumeSlider
private struct VerticalVolumeSlider: View {
    @Binding var value: Double
    let onEditingChanged: (Bool) -> Void

    @State private var isEditing = false

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let thumbY = thumbY(height: height)

            ZStack(alignment: .top) {
                Capsule(style: .continuous)
                    .fill(Color(hex: 0xECEFF3))
                    .frame(width: VolumePanelLayout.sliderTrackWidth, height: height)

                Capsule(style: .continuous)
                    .fill(Color.accentPrimary)
                    .frame(
                        width: VolumePanelLayout.sliderTrackWidth,
                        height: height - thumbY
                    )
                    .offset(y: thumbY)

                Circle()
                    .fill(Color.white)
                    .frame(width: VolumePanelLayout.sliderThumbSize, height: VolumePanelLayout.sliderThumbSize)
                    .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 1)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: 0xE2E6EB), lineWidth: 0.5)
                    )
                    .offset(y: thumbY - VolumePanelLayout.sliderThumbSize / 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                // 系统 Slider 在 Xcode Preview/旋转后 tint 不稳定，这里自绘以保证红色主题一致。
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        beginEditingIfNeeded()
                        updateValue(at: gesture.location.y, height: height)
                    }
                    .onEnded { _ in
                        isEditing = false
                        onEditingChanged(false)
                    }
            )
        }
    }

    // MARK: Private
    private func thumbY(height: CGFloat) -> CGFloat {
        let normalizedValue = value.clamped(to: 0...1)
        return height * (1 - normalizedValue)
    }

    private func updateValue(at yPosition: CGFloat, height: CGFloat) {
        guard height > 0 else { return }

        let normalizedY = (yPosition / height).clamped(to: 0...1)
        value = 1 - normalizedY
    }

    private func beginEditingIfNeeded() {
        guard !isEditing else { return }

        isEditing = true
        onEditingChanged(true)
    }
}

// MARK: - VolumePanelLayout
enum VolumePanelLayout {
    static let panelWidth: CGFloat = 40
    static let panelHeight: CGFloat = 140
    static let panelSpacing: CGFloat = 10
    static let panelCornerRadius: CGFloat = 8
    static let sliderLength: CGFloat = 90
    static let sliderTrackWidth: CGFloat = 5
    static let sliderThumbSize: CGFloat = 14
    static let arrowSize: CGFloat = 14

    // 阴影由 AppKit 根视图绘制，这些 padding 给阴影留出自然衰减空间，避免被窗口边界裁成矩形。
    static let shadowHorizontalInset: CGFloat = 12
    static let shadowTopInset: CGFloat = 2
    static let shadowBottomInset: CGFloat = 14
    static let bubbleHeight = panelHeight + arrowSize / 2
    static let contentSize = CGSize(
        width: panelWidth + shadowHorizontalInset * 2,
        height: bubbleHeight + shadowTopInset + shadowBottomInset
    )
}

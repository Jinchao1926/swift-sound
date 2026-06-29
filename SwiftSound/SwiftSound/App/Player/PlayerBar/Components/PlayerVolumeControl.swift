//
//  PlayerVolumeControl.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import SwiftUI

struct PlayerVolumeControl: View {
    let volume: Double
    let isMuted: Bool
    let onSetVolume: (Double) -> Void
    let onToggleMute: () -> Void

    @Environment(\.playerBarStyle) private var style
    @State private var isPanelPresented = false
    @State private var isHoveringButton = false
    @State private var isHoveringPanel = false

    var body: some View {
        PlayerIconButton(systemName: iconName, action: onToggleMute)
            .help(isMuted ? "取消静音" : "静音")
            .onHover { updateButtonHover($0) }
            .overlay(alignment: .bottom) {
                if isPanelPresented {
                    VolumePanel(
                        volume: volume,
                        isMuted: isMuted,
                        onSetVolume: onSetVolume
                    )
                    .offset(y: -Layout.panelBottomOffset)
                    .onHover { updatePanelHover($0) }
                    .zIndex(Layout.panelZIndex)
                }
            }
            .animation(.easeOut(duration: 0.12), value: isPanelPresented)
    }

    private var iconName: String {
        if isMuted || volume == 0 {
            return "speaker.slash"
        }
        if volume < 0.3 {
            return "speaker.wave.1"
        }
        if volume < 0.6 {
            return "speaker.wave.2"
        }
        return "speaker.wave.3"
    }

    private func updateButtonHover(_ isHovering: Bool) {
        isHoveringButton = isHovering
        if isHovering {
            isPanelPresented = true
        } else {
            schedulePanelClose()
        }
    }

    private func updatePanelHover(_ isHovering: Bool) {
        isHoveringPanel = isHovering
        if isHovering {
            isPanelPresented = true
        } else {
            schedulePanelClose()
        }
    }

    private func schedulePanelClose() {
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(120))
            if !isHoveringButton && !isHoveringPanel {
                isPanelPresented = false
            }
        }
    }

    private enum Layout {
        static let panelBottomOffset: CGFloat = 36
        static let panelZIndex: Double = 10
    }
}

private struct VolumePanel: View {
    let volume: Double
    let isMuted: Bool
    let onSetVolume: (Double) -> Void

    @Environment(\.playerBarStyle) private var style

    var body: some View {
        VStack(spacing: Layout.panelSpacing) {
            Slider(value: volumeBinding, in: 0...1)
                .controlSize(.small)
                .tint(.accentPrimary)
                .frame(width: Layout.sliderLength)
                .rotationEffect(.degrees(-90))
                .frame(width: Layout.panelWidth, height: Layout.sliderLength)

            Text(volumeText)
                .font(.font12)
                .foregroundStyle(style.secondaryTextColor)
                .monospacedDigit()
        }
        .frame(width: Layout.panelWidth, height: Layout.panelHeight)
        .background(
            RoundedRectangle(cornerRadius: Layout.panelCornerRadius, style: .continuous)
                .fill(style.volumePanelBackgroundColor)
                .shadow(color: Color.black.opacity(0.14), radius: 12, x: 0, y: 4)
        )
        .overlay(alignment: .bottom) {
            RotatedSquare()
                .fill(style.volumePanelBackgroundColor)
                .frame(width: Layout.arrowSize, height: Layout.arrowSize)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                .offset(y: Layout.arrowOffset)
        }
    }

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

    private enum Layout {
        static let panelWidth: CGFloat = 40
        static let panelHeight: CGFloat = 140
        static let panelSpacing: CGFloat = 10
        static let panelCornerRadius: CGFloat = 8
        static let sliderLength: CGFloat = 90
        static let arrowSize: CGFloat = 14
        static let arrowOffset: CGFloat = 7
    }
}

private struct RotatedSquare: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    @Previewable @State var volume = 0.34
    @Previewable @State var isMuted = false

    HStack(spacing: 0) {
        VStack {
            Spacer()
            PlayerVolumeControl(
                volume: volume,
                isMuted: isMuted,
                onSetVolume: {
                    volume = $0
                    isMuted = $0 == 0
                },
                onToggleMute: {
                    isMuted.toggle()
                }
            )
            .padding(20)
        }
        .frame(width: 100, height: 300)

        let style = PlayerBarStyle.fullPlayer(themeColor: Color.yellow)
        VStack {
            Spacer()
            PlayerVolumeControl(
                volume: volume,
                isMuted: isMuted,
                onSetVolume: {
                    volume = $0
                    isMuted = $0 == 0
                },
                onToggleMute: {
                    isMuted.toggle()
                }
            )
            .padding(20)
        }
        .frame(width: 100, height: 300)
        .background(style.backgroundColor)
        .environment(\.playerBarStyle, style)
    }
}

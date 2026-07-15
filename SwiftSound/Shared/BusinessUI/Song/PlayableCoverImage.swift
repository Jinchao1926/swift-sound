//
//  PlayableCoverImage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/15.
//

import SwiftUI

struct PlayableCoverImage: View {
    enum ControlIcon {
        case play
        case pause

        var systemName: String {
            switch self {
            case .play:
                return "play.fill"
            case .pause:
                return "pause.fill"
            }
        }
    }

    let url: URL?
    let imageSize: CGFloat
    let cornerRadius: CGFloat
    let overlayOpacity: Double
    let playButtonFont: Font
    let playButtonSize: CGFloat
    let animatesHoverEffects: Bool
    let controlIcon: ControlIcon
    let onControlTap: () -> Void

    @State private var isHovering = false

    init(
        url: URL?,
        imageSize: CGFloat,
        cornerRadius: CGFloat,
        overlayOpacity: Double = 0.38,
        playButtonFont: Font = .font20,
        playButtonSize: CGFloat = 24,
        animatesHoverEffects: Bool = true,
        controlIcon: ControlIcon = .play,
        onControlTap: @escaping () -> Void
    ) {
        self.url = url
        self.imageSize = imageSize
        self.cornerRadius = cornerRadius
        self.overlayOpacity = overlayOpacity
        self.playButtonFont = playButtonFont
        self.playButtonSize = playButtonSize
        self.animatesHoverEffects = animatesHoverEffects
        self.controlIcon = controlIcon
        self.onControlTap = onControlTap
    }

    var body: some View {
        Button(action: onControlTap) {
            ZStack {
                RemoteImage(url: url)

                if isHovering {
                    Color.black.opacity(overlayOpacity)
                    playIcon
                }
            }
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }

    @ViewBuilder
    private var playIcon: some View {
        let view = PlayableCoverControlIcon(
            systemName: controlIcon.systemName,
            font: playButtonFont,
            size: playButtonSize,
            isScaled: animatesHoverEffects && isHovering
        )

        if animatesHoverEffects {
            view.transition(.scale(scale: 0.9).combined(with: .opacity))
        } else {
            view
        }
    }
}

private struct PlayableCoverControlIcon: View {
    let systemName: String
    let font: Font
    let size: CGFloat
    let isScaled: Bool

    var body: some View {
        Image(systemName: systemName)
            .font(font)
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .scaleEffect(isScaled ? 1.16 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isScaled)
    }
}

#Preview {
    HStack(spacing: 24) {
        PlayableCoverImage(
            url: nil,
            imageSize: 65,
            cornerRadius: 8,
            onControlTap: {}
        )

        PlayableCoverImage(
            url: nil,
            imageSize: 48,
            cornerRadius: 6,
            playButtonFont: .font16,
            playButtonSize: 22,
            animatesHoverEffects: false,
            controlIcon: .pause,
            onControlTap: {}
        )
    }
    .padding()
}

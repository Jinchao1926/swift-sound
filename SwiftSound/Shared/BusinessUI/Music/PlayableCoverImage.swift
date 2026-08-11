//
//  PlayableCoverImage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/15.
//

import SwiftUI

struct PlayableCoverImage: View {
    struct Style {
        let imageSize: CGFloat
        let cornerRadius: CGFloat
        let overlayOpacity: Double
        let playButtonFont: Font
        let playButtonSize: CGFloat
        let animatesHoverEffects: Bool

        init(
            imageSize: CGFloat,
            cornerRadius: CGFloat,
            overlayOpacity: Double = 0.38,
            playButtonFont: Font = .font20,
            playButtonSize: CGFloat = 24,
            animatesHoverEffects: Bool = true
        ) {
            self.imageSize = imageSize
            self.cornerRadius = cornerRadius
            self.overlayOpacity = overlayOpacity
            self.playButtonFont = playButtonFont
            self.playButtonSize = playButtonSize
            self.animatesHoverEffects = animatesHoverEffects
        }
    }

    struct InteractionState {
        let isHovering: Bool
        let icon: PlaybackControl
        let showsControl: Bool

        init(
            isHovering: Bool = false,
            icon: PlaybackControl = .play,
            showsControl: Bool = false
        ) {
            self.isHovering = isHovering
            self.icon = icon
            self.showsControl = showsControl
        }
    }

    let url: URL?
    let style: Style
    let interactionState: InteractionState
    let onControlTap: () -> Void

    @State private var isPointerHovering = false

    init(
        url: URL?,
        style: Style,
        interactionState: InteractionState = .init(),
        onControlTap: @escaping () -> Void
    ) {
        self.url = url
        self.style = style
        self.interactionState = interactionState
        self.onControlTap = onControlTap
    }

    var body: some View {
        Button(action: onControlTap) {
            ZStack {
                RemoteImage(url: url)

                if effectiveHovering || interactionState.showsControl {
                    Color.black.opacity(style.overlayOpacity)
                    playbackIcon
                }
            }
            .frame(width: style.imageSize, height: style.imageSize)
            .rounded(radius: style.cornerRadius)
        }
        .buttonStyle(.plain)
        .onHover { isPointerHovering = $0 }
        .pointerStyle(.link)
    }

    @ViewBuilder
    private var playbackIcon: some View {
        let view = PlaybackControlIcon(
            control: interactionState.icon,
            font: style.playButtonFont,
            size: style.playButtonSize,
            animatesHoverEffects: style.animatesHoverEffects
        )

        if style.animatesHoverEffects {
            view.transition(.scale(scale: 0.9).combined(with: .opacity))
        } else {
            view
        }
    }

    private var effectiveHovering: Bool {
        isPointerHovering || interactionState.isHovering
    }
}

#Preview {
    HStack(spacing: 24) {
        PlayableCoverImage(
            url: nil,
            style: .init(imageSize: 65, cornerRadius: 8),
            onControlTap: {}
        )

        PlayableCoverImage(
            url: nil,
            style: .init(
                imageSize: 48,
                cornerRadius: 6,
                playButtonFont: .font16,
                playButtonSize: 22,
                animatesHoverEffects: false
            ),
            interactionState: .init(isHovering: true, icon: .pause),
            onControlTap: {}
        )
    }
    .padding()
}

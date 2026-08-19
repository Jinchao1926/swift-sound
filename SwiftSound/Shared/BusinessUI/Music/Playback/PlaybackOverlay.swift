//
//  PlaybackOverlay.swift
//  SwiftSound
//

import SwiftUI

struct PlaybackOverlayConfiguration {
    enum Style {
        case dark
        case light

        @ViewBuilder
        func overlayView(opacity: Double) -> some View {
            switch self {
            case .dark:
                Color.black.opacity(opacity)
            case .light:
                LinearGradient(
                    colors: [
                        Color.white.opacity(opacity),
                        Color.white.opacity(0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    enum Placement {
        case center
        case bottomTrailing(inset: CGFloat)

        var alignment: Alignment {
            switch self {
            case .center:
                return .center
            case .bottomTrailing:
                return .bottomTrailing
            }
        }

        var controlInsets: EdgeInsets {
            switch self {
            case .center:
                return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            case .bottomTrailing(let inset):
                return EdgeInsets(top: 0, leading: 0, bottom: inset, trailing: inset)
            }
        }
    }

    enum Visibility {
        case onHover
        case always
    }

    enum TapTarget {
        case playButton
        case content
    }

    let placement: Placement
    let visibility: Visibility
    let style: Style
    let control: PlaybackControl
    let tapTarget: TapTarget
    let buttonSize: CGFloat
    let iconFont: Font

    init(
        placement: Placement = .center,
        visibility: Visibility = .onHover,
        style: Style = .dark,
        control: PlaybackControl = .play,
        tapTarget: TapTarget = .playButton,
        buttonSize: CGFloat = 32,
        iconFont: Font = .font24
    ) {
        self.placement = placement
        self.visibility = visibility
        self.style = style
        self.control = control
        self.tapTarget = tapTarget
        self.buttonSize = buttonSize
        self.iconFont = iconFont
    }
}

private enum PlaybackOverlayDefaults {
    static let overlayOpacity: Double = 0.38
    static let hoverScale: CGFloat = 1.12
    static let hoverAnimation = Animation.spring(response: 0.22, dampingFraction: 0.72)
}

private struct PlaybackOverlayModifier: ViewModifier {
    let configuration: PlaybackOverlayConfiguration
    let isExternalHovering: Bool
    let onPlaybackTap: (() -> Void)?

    @State private var isPointerHovering = false
    @State private var isControlHovering = false

    func body(content: Content) -> some View {
        tappableContent(content)
            .overlay {
                if showsOverlay {
                    ZStack(alignment: configuration.placement.alignment) {
                        configuration.style.overlayView(opacity: PlaybackOverlayDefaults.overlayOpacity)
                            .allowsHitTesting(false)

                        playbackControl
                            .padding(configuration.placement.controlInsets)
                    }
                }
            }
            .onHover { isPointerHovering = $0 }
            .animation(.easeOut(duration: 0.12), value: showsOverlay)
    }
}

private extension PlaybackOverlayModifier {
    var showsOverlay: Bool {
        switch configuration.visibility {
        case .onHover:
            return isPointerHovering || isExternalHovering
        case .always:
            return true
        }
    }

    var scaleFactor: CGFloat {
        guard isControlHovering else {
            return 1
        }
        return PlaybackOverlayDefaults.hoverScale
    }
}

private extension PlaybackOverlayModifier {
    @ViewBuilder
    func tappableContent(_ content: Content) -> some View {
        if let onPlaybackTap, configuration.tapTarget == .content {
            content
                .contentShape(Rectangle())
                .onTapGesture(perform: onPlaybackTap)
                .pointerStyle(.link)
        } else {
            content
        }
    }

    @ViewBuilder
    var playbackControl: some View {
        if let onPlaybackTap, configuration.tapTarget == .playButton {
            Button(action: onPlaybackTap) {
                playbackControlIcon
            }
            .buttonStyle(.plain)
            .pointerStyle(.link)
            .onHover { isControlHovering = $0 }
        } else {
            playbackControlIcon
                .allowsHitTesting(false)
        }
    }

    var playbackControlIcon: some View {
        PlaybackControlIcon(
            control: configuration.control,
            font: configuration.iconFont,
            size: configuration.buttonSize,
            animatesHoverEffects: false
        )
        .scaleEffect(scaleFactor)
        .animation(PlaybackOverlayDefaults.hoverAnimation, value: isControlHovering)
    }
}

extension View {
    func playbackOverlay(
        configuration: PlaybackOverlayConfiguration = .init(),
        isExternalHovering: Bool = false,
        onPlaybackTap: (() -> Void)? = nil
    ) -> some View {
        modifier(
            PlaybackOverlayModifier(
                configuration: configuration,
                isExternalHovering: isExternalHovering,
                onPlaybackTap: onPlaybackTap
            )
        )
    }
}

#Preview("Playback overlays") {
    VStack {
        Color.red.opacity(0.28)
            .frame(width: 100, height: 100)
            .playbackOverlay(
                configuration: .init(
                    buttonSize: 28,
                    iconFont: .font20
                ),
                isExternalHovering: true,
                onPlaybackTap: {
                    debugPrint("onPlay")
                }
            )
            .rounded(radius: 8)

        Color.blue.opacity(0.35)
            .frame(width: 100, height: 100)
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: 10),
                    style: .light,
                    control: .pause,
                    buttonSize: 32,
                    iconFont: .font24
                ),
                isExternalHovering: false,
            )
            .rounded(radius: 8)
    }
    .padding()
}

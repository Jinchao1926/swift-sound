//
//  PlayableControlIcon.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

enum PlaybackControl {
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

struct PlaybackControlIcon: View {
    let control: PlaybackControl
    let font: Font
    let size: CGFloat
    let animatesHoverEffects: Bool

    @State private var isHovering = false

    var body: some View {
        Image(systemName: control.systemName)
            .font(font)
            .foregroundStyle(backgroundColor)
            .frame(width: size, height: size)
            .scaleEffect(isScaled ? 1.16 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isScaled)
            .onHover { isHovering = $0 }
    }

    private var isScaled: Bool {
        animatesHoverEffects && isHovering
    }

    private var backgroundColor: Color {
        guard animatesHoverEffects else { return .white }

        return isHovering ? .white : .white.opacity(0.8)
    }
}

#Preview {
    VStack {
        PlaybackControlIcon(
            control: .play,
            font: .font20,
            size: 24,
            animatesHoverEffects: true
        )
    }
    .padding()
    .background(Color.black)
}

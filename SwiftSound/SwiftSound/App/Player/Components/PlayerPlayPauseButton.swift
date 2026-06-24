//
//  PlayerPlayPauseButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/23.
//

import SwiftUI

struct PlayerPlayPauseButton: View {
    let isPlaying: Bool
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: Layout.iconSize, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: Layout.buttonSize, height: Layout.buttonSize)
                .background {
                    Circle()
                        .fill(backgroundColor)
                }
                .scaleEffect(isHovering ? Layout.hoverScale : 1)
                .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isHovering)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
        .help(helpText)
    }
}

private extension PlayerPlayPauseButton {
    var systemName: String {
        isPlaying ? "pause.fill" : "play.fill"
    }

    var helpText: String {
        isPlaying ? "暂停" : "播放"
    }

    var backgroundColor: Color {
        Color.accentPrimary.mix(with: .black, by: isHovering ? 0.12 : 0)
    }

    enum Layout {
        static let buttonSize: CGFloat = 40
        static let iconSize: CGFloat = 23
        static let hoverScale: CGFloat = 1.08
    }
}

#Preview {
    HStack(spacing: 20) {
        PlayerPlayPauseButton(isPlaying: false) {}
        PlayerPlayPauseButton(isPlaying: true) {}
    }
    .padding()
}

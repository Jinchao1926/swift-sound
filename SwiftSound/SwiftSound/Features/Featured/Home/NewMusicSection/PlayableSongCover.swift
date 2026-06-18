//
//  PlayableSongCover.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/18.
//

import SwiftUI

struct PlayableSongCover: View {
    let url: URL?
    let isHovering: Bool
    let imageSize: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RemoteImage(url: url)

            if isHovering {
                Color.black.opacity(0.38)
                    .transition(.opacity)

                SongCoverPlayButton()
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .frame(width: imageSize, height: imageSize)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

private struct SongCoverPlayButton: View {
    @State private var isHovering = false

    var body: some View {
        Button {
            // Playback wiring belongs to the player feature.
        } label: {
            Image(systemName: "play.fill")
                .font(.font20)
                .foregroundStyle(.white)
                .offset(x: 1)
                .frame(width: 24, height: 24)
                .scaleEffect(isHovering ? 1.16 : 1)
                .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isHovering)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }
}

#Preview {
    PlayableSongCover()
}

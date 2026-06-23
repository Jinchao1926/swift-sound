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
    let onPlay: () -> Void

    init(
        url: URL? = nil,
        isHovering: Bool = false,
        imageSize: CGFloat = Layout.imageSize,
        cornerRadius: CGFloat = Layout.cornerRadius,
        onPlay: @escaping () -> Void
    ) {
        self.url = url
        self.isHovering = isHovering
        self.imageSize = imageSize
        self.cornerRadius = cornerRadius
        self.onPlay = onPlay
    }

    var body: some View {
        ZStack {
            RemoteImage(url: url)

            if isHovering {
                Color.black.opacity(0.38)
                    .transition(.opacity)

                SongCoverPlayButton(onPlay: onPlay)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .frame(width: imageSize, height: imageSize)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .animation(.easeInOut(duration: 0.16), value: isHovering)
    }

    enum Layout {
        static let imageSize: CGFloat = 65
        static let cornerRadius: CGFloat = 8
    }
}

private struct SongCoverPlayButton: View {
    let onPlay: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button {
            onPlay()
        } label: {
            Image(systemName: "play.fill")
                .font(.font20)
                .foregroundStyle(.white)
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
    PlayableSongCover(isHovering: true) {
        // ...
    }
}

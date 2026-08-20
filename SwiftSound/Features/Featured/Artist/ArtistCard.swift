//
//  ArtistCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import SwiftUI

struct ArtistCard: View {
    let artist: Artist

    @State private var isHovering = false

    var body: some View {
        VStack(spacing: Layout.contentSpacing) {
            Avatar(url: artist.avatarURL)
                .circularPlaybackOverlay(
                    configuration: .init(
                        buttonSize: Layout.playbackSize,
                        iconFont: .font32
                    ),
                    isExternalHovering: isHovering,
                    onPlaybackTap: {}
                )

            Text(artist.name)
                .font(.font14)
                .foregroundStyle(Color.textPrimary)

            if let musicSize = artist.musicSize {
                Text("单曲: \(musicSize)")
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(20)
        .onHover { isHovering = $0 }
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(isHovering ? .white : .clear)
        )
    }
}

private extension ArtistCard {
    enum Layout {
        static let contentSpacing: CGFloat = 10
        static let playbackSize: CGFloat = 25
    }
}

#Preview {
    ArtistCard(artist: .preview)
        .frame(width: 180)
        .padding()
        .background(Color.divider)
}

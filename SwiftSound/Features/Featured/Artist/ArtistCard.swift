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
        VStack(spacing: 10) {
            PlayableCoverImage(
                url: artist.avatarURL,
                style: .init(
                    imageSize: 138,
                    cornerRadius: 69,
                    playButtonFont: .font32,
                    playButtonSize: 25
                ),
                interactionState: .init(isHovering: isHovering)
            ) {}

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

#Preview {
    VStack {
        ArtistCard(artist: .preview)
    }
    .padding()
    .background(Color.divider)
}

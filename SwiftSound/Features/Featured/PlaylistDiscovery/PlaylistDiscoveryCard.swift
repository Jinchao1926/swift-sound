//
//  PlaylistDiscoveryCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import SwiftUI

struct PlaylistDiscoveryCard: View {
    let playlist: Playlist
    let onPlay: () -> Void

    @State private var isHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            playlistCover

            metadata
        }
        .frame(width: Layout.width)
        .background(isHovering ? Color.white : Color.clear)
        .rounded(radius: Layout.radius)
        .onHover { isHovering = $0 }
    }

    private var playlistCover: some View {
        RemoteImage(url: playlist.coverURL)
            .frame(width: Layout.width, height: Layout.width)
            .overlay(alignment: .topLeading) {
                PlayCountBadge(count: playlist.playCount, fontSize: 11)
                    .padding(Layout.buttonPadding)
            }
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.buttonPadding),
                    iconFont: .font32
                ),
                isExternalHovering: isHovering,
                onPlaybackTap: {}
            )
            .rounded(radius: Layout.radius)
    }

    private var metadata: some View {
        VStack(alignment: .leading, spacing: Layout.textSpacing) {
            Text(playlist.name)
                .font(.font13)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            Text(playlist.trackCount.formattedSongCount())
                .font(.font13)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
        }
        .padding(.horizontal, Layout.textPadding)
        .padding(.vertical, Layout.textPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension PlaylistDiscoveryCard {
    enum Layout {
        static let width: CGFloat = 116
        static let radius: CGFloat = 6

        static let textSpacing: CGFloat = 4
        static let textPadding: CGFloat = 6

        static let playButtonSize: CGFloat = 26
        static let buttonPadding: CGFloat = 12
    }
}

#Preview {
    VStack {
        PlaylistDiscoveryCard(playlist: .preview) {}
    }
    .padding()
    .background(Color.surfacePrimary)
}

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
            playlistInfo
        }
        .background(isHovering ? Color.white : Color.clear)
        .rounded()
        .onHover { isHovering = $0 }
    }

    private var playlistCover: some View {
        RemoteImage(url: playlist.coverURL)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topLeading) {
                PlayCountBadge(count: playlist.playCount, fontSize: 11)
                    .padding(Layout.coverOverlayInset)
            }
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.coverOverlayInset),
                    iconFont: .font32
                ),
                isExternalHovering: isHovering,
                onPlaybackTap: onPlay
            )
            .rounded()
    }

    private var playlistInfo: some View {
        VStack(alignment: .leading, spacing: Layout.infoTextSpacing) {
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
        .padding(Layout.infoPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension PlaylistDiscoveryCard {
    enum Layout {
        static let infoTextSpacing: CGFloat = 4
        static let infoPadding: CGFloat = 6
        static let coverOverlayInset: CGFloat = 12
    }
}

#Preview {
    PlaylistDiscoveryCard(playlist: .preview) {}
        .frame(width: 116)
        .padding()
        .background(Color.surfacePrimary)
}

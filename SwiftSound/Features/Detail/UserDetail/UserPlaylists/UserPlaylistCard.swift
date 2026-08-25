//
//  UserPlaylistCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/24.
//

import SwiftUI

struct UserPlaylistCard: View {
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
            .overlay(alignment: .topTrailing) {
                PlayCountBadge(count: playlist.playCount, fontSize: 14)
                    .padding(Layout.coverOverlayInset)
            }
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.coverOverlayInset),
                    buttonSize: Layout.playbackButtonSize,
                    iconFont: .font24
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

private extension UserPlaylistCard {
    enum Layout {
        static let infoTextSpacing: CGFloat = 4
        static let infoPadding: CGFloat = 6
        static let coverOverlayInset: CGFloat = 12
        static let playbackButtonSize: CGFloat = 24
    }
}

#Preview {
    UserPlaylistCard(playlist: .preview) {}
        .frame(width: 178)
        .padding()
        .background(Color.surfacePrimary)
}

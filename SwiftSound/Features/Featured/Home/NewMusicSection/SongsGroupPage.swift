//
//  SongsGroupPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct SongsGroupPage: View {
    let songs: [NewSong]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(songs) {
                NewSongCover(song: $0)
            }
        }
    }
}

// MARK: - NewSongCover
struct NewSongCover: View {
    let song: NewSong

    @State private var isHovering = false
    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            PlayableSongCover(
                url: URL(string: song.picUrl)
            ) {
                playerStore.send(.playSong(song.song))
            }

            songInfo

            Spacer(minLength: Layout.contentSpacing)

            hoverActions
        }
        .padding(Layout.inset)
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(isHovering ? Color.white : Color.clear)
        )
        .contentShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
        .onHover { isHovering = $0 }
    }

    enum Layout {
        static let inset: CGFloat = 10
        static let cornerRadius: CGFloat = 8
        static let contentSpacing: CGFloat = 10
        static let metadataSpacing: CGFloat = 5
        static let actionSpacing: CGFloat = 18
    }
}

private extension NewSongCover {
    var songInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(song.name)
                .font(.font14)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            metadata
        }
    }

    var metadata: some View {
        HStack(spacing: Layout.metadataSpacing) {
            SongBadges.quality(isHiRes: song.song.isHiRes)

            if song.hasMV {
                SongBadges.mv
            }

            if song.song.hasOriginalBadge {
                SongBadges.original
            }

            if let artistName = song.artistName {
                Text(artistName)
                    .font(.font12)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    var hoverActions: some View {
        if isHovering {
            HStack(spacing: Layout.actionSpacing) {
                IconButton(systemName: "arrow.down.circle", font: .font20).help("下载")
                IconButton(systemName: "heart", font: .font20).help("喜欢")
                IconButton(systemName: "ellipsis", font: .font20).help("更多")
            }
            .padding(.trailing, 10)
            .transition(.opacity)
        }
    }
}

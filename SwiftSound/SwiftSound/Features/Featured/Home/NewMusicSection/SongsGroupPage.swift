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

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            PlayableSongCover(
                url: URL(string: song.picUrl),
                isHovering: isHovering,
                imageSize: Layout.imageSize,
                cornerRadius: Layout.cornerRadius
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(song.name)
                    .font(.font14)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 5) {
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

            Spacer(minLength: Layout.contentSpacing)

            if isHovering {
                HStack(spacing: 18) {
                    IconButton(systemName: "arrow.down.circle", font: .font20).help("下载")
                    IconButton(systemName: "heart", font: .font20).help("喜欢")
                    IconButton(systemName: "ellipsis", font: .font20).help("更多")
                }
                .padding(.trailing, 10)
                .transition(.opacity)
            }
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
        static let imageSize: CGFloat = 65
        static let rowHeight: CGFloat = 86
        static let cornerRadius: CGFloat = 8
        static let contentSpacing: CGFloat = 10
    }
}

//
//  SongTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct SongTable: View {
    let songs: [Song]
    let style: DataTableStyle

    @EnvironmentObject private var playerStore: PlayerStore

    init(
        songs: [Song],
        style: DataTableStyle = .plain
    ) {
        self.songs = songs
        self.style = style
    }

    var body: some View {
        DataTable(
            rows: rows,
            columns: columns,
            style: style
        )
    }

    private var rows: [SongTableRow] {
        songs.map { SongTableRow(song: $0) }
    }

    private var columns: [DataTableColumn<SongTableRow>] {
        [
            DataTableColumn(
                id: "index",
                title: "#",
                width: .fixed(Layout.indexWidth),
                alignment: .center,
                content: { row, context in
                    MusicTableIndexCell(
                        index: context.index + 1,
                        isRowHovering: context.isHovering
                    ) {
                        playerStore.send(.playSong(row.song))
                    }
                }
            ),

            DataTableColumn(
                id: "title",
                title: "标题",
                width: .flexible(min: Layout.titleMinWidth),
                alignment: .leading,
                sort: { lhs, rhs in
                    lhs.song.name.localizedStandardCompare(rhs.song.name)
                },
                content: { row, context in
                    MusicTableTitleCell(
                        imageURL: row.imageURL,
                        title: row.title,
                        titleSuffix: row.titleSuffix,
                        subTitle: row.subTitle,
                        isRowHovering: context.isHovering,
                        onAction: {
                            handleTitleAction($0, song: row.song)
                        },
                        badges: {
                            SongTableBadges(row: row)
                        }
                    )
                }
            ),

            DataTableColumn(
                id: "album",
                title: "专辑",
                width: .fixed(Layout.albumWidth),
                sort: { lhs, rhs in
                    lhs.song.album.name.localizedStandardCompare(rhs.song.album.name)
                },
                content: { row, _ in
                    Text(row.song.album.name)
                        .font(.font14)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                }
            ),

            DataTableColumn(
                id: "liked",
                title: "喜欢",
                width: .fixed(Layout.likedWidth),
                content: { row, _ in
                    MusicTableFavoriteButton(liked: row.isLiked)
                }
            ),

            DataTableColumn(
                id: "duration",
                title: "时长",
                width: .fixed(Layout.durationWidth),
                sort: { lhs, rhs in
                    lhs.song.duration.compare(rhs.song.duration)
                },
                content: { row, _ in
                    Text(row.durationText)
                        .font(.font13)
                        .foregroundStyle(Color.textTertiary)
                        .monospacedDigit()
                        .lineLimit(1)
                }
            )
        ]
    }

    private enum Layout {
        static let indexWidth: CGFloat = 54
        static let titleMinWidth: CGFloat = 160
        static let albumWidth: CGFloat = 220
        static let likedWidth: CGFloat = 58
        static let durationWidth: CGFloat = 65
    }

    private func handleTitleAction(_ action: MusicTableAction, song: Song) {
        switch action {
        case .addToPlaylist:
            playerStore.send(.appendToQueue(song))

        case .download, .comment, .more:
            break
        }
    }
}

#Preview {
    VStack {
        SongTable(songs: Array.songsPreview)
    }
    .padding(20)
    .frame(width: 800)
    .background(Color.surfaceSecondary)
    .environmentObject(PlayerStore())
}

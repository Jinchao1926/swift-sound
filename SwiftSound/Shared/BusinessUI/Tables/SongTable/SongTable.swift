//
//  SongTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct SongTable: View {
    let songs: [Song]
    let style: SongTableStyle

    @EnvironmentObject private var playerStore: PlayerStore

    init(
        songs: [Song],
        style: SongTableStyle = .default
    ) {
        self.songs = songs
        self.style = style
    }

    var body: some View {
        MusicTable(
            rows: rows,
            columns: columns,
            style: style.dataTableStyle,
            onPlaybackAction: handlePlaybackAction
        )
    }
}

private extension SongTable {
    var rows: [SongTableRow] {
        songs.map { SongTableRow(song: $0, playbackStatus: playbackStatus(for: $0)) }
    }

    var columns: [DataTableColumn<SongTableRow>] {
        var columns = [titleColumn]

        if style.showsAlbumColumn {
            columns.append(albumColumn)
        }

        columns.append(likedColumn)
        columns.append(durationColumn)

        if style.showsPopularityColumn {
            columns.append(popularityColumn)
        }

        return columns
    }

    func playbackStatus(for song: Song) -> MusicTablePlaybackStatus {
        guard playerStore.state.currentSong?.id == song.id else {
            return .notCurrent
        }

        return playerStore.state.playbackState == .playing
            ? .currentPlaying
            : .currentPaused
    }

    func handlePlaybackAction(_ action: MusicTablePlaybackAction, row: SongTableRow) {
        switch action {
        case .play:
            guard let startIndex = songs.firstIndex(where: { $0.id == row.id }) else { return }
            playerStore.send(.playQueue(songs, startIndex: startIndex))
        case .pause:
            playerStore.send(.pause)
        }
    }

    func handleTitleAction(_ action: SongTableAction, song: Song) {
        switch action {
        case .addToPlaylist:
            playerStore.send(.appendToQueue(song))

        case .download, .comment, .more:
            break
        }
    }
}

// MARK: - Columns
private extension SongTable {
    var titleColumn: DataTableColumn<SongTableRow> {
        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: Layout.titleMinWidth),
            sortComparator: { lhs, rhs in
                lhs.song.name.localizedStandardCompare(rhs.song.name)
            },
            content: { row, context in
                SongTableTitleCell(
                    row: row,
                    rowState: row.rowState(in: context),
                    onAction: {
                        handleTitleAction($0, song: row.song)
                    }
                )
            }
        )
    }

    var albumColumn: DataTableColumn<SongTableRow> {
        DataTableColumn(
            id: "album",
            title: "专辑",
            width: .fixed(Layout.albumWidth),
            sortComparator: { lhs, rhs in
                lhs.song.album.name.localizedStandardCompare(rhs.song.album.name)
            },
            content: { row, _ in
                RouteLink(route: .album(id: row.song.album.id)) {
                    Text(row.song.album.name)
                        .font(.font13)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                }
            }
        )
    }

    var likedColumn: DataTableColumn<SongTableRow> {
        DataTableColumn(
            id: "liked",
            title: "喜欢",
            width: .fixed(Layout.likedWidth),
            content: { row, _ in
                MusicTableFavoriteButton(liked: row.isLiked)
            }
        )
    }

    var durationColumn: DataTableColumn<SongTableRow> {
        DataTableColumn(
            id: "duration",
            title: "时长",
            width: .fixed(Layout.durationWidth),
            sortComparator: { lhs, rhs in
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
    }

    var popularityColumn: DataTableColumn<SongTableRow> {
        DataTableColumn(
            id: "popularity",
            title: "热度",
            width: .fixed(Layout.popularityWidth),
            sortComparator: { lhs, rhs in
                lhs.popularityValue.compare(rhs.popularityValue)
            },
            content: { row, _ in
                SongPopularityBar(value: row.popularityValue)
            }
        )
    }
}

// MARK: - Layout
private extension SongTable {
    enum Layout {
        static let titleMinWidth: CGFloat = 160
        static let albumWidth: CGFloat = 220
        static let likedWidth: CGFloat = 58
        static let durationWidth: CGFloat = 65
        static let popularityWidth: CGFloat = 92
    }
}

#Preview {
    VStack {
        SongTable(
            songs: Array.songsPreview,
            style: .albumSongs
        )
    }
    .padding(20)
    .frame(width: 800)
    .background(Color.surfaceSecondary)
    .environmentObject(PlayerStore())
}

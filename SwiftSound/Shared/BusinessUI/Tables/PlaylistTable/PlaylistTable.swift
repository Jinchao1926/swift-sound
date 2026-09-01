//
//  PlaylistTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

struct PlaylistTable: View {
    let playlists: [Playlist]

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        MusicTable(
            rows: rows,
            columns: columns,
            onPlaybackAction: handlePlaybackAction
        )
    }
}

private extension PlaylistTable {
    var rows: [PlaylistTableRow] {
        playlists.map { PlaylistTableRow(playlist: $0, playbackStatus: playbackStatus(for: $0)) }
    }

    var columns: [DataTableColumn<PlaylistTableRow>] {
        [titleColumn, songCountColumn, creatorColumn]
    }

    func playbackStatus(for _: Playlist) -> MusicTablePlaybackStatus {
        .notCurrent
    }

    func handlePlaybackAction(_ action: MusicTablePlaybackAction, row: PlaylistTableRow) {
        switch action {
        case .play:
            break
        case .pause:
            playerStore.send(.pause)
        }
    }

    func handleTitleAction(_ action: PlaylistTableAction, playlist: Playlist) {
        switch action {
        case .favorite, .more:
            break
        }
    }
}

// MARK: - Columns
private extension PlaylistTable {
    var titleColumn: DataTableColumn<PlaylistTableRow> {
        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: Layout.titleMinWidth),
            alignment: .leading,
            content: { row, context in
                PlaylistTableTitleCell(
                    row: row,
                    rowState: row.rowState(in: context),
                    onAction: {
                        handleTitleAction($0, playlist: row.playlist)
                    }
                )
            }
        )
    }

    var songCountColumn: DataTableColumn<PlaylistTableRow> {
        DataTableColumn(
            id: "songCount",
            title: "歌曲数",
            width: .fixed(Layout.songCountWidth),
            content: { row, _ in
                Text(row.songCount)
                    .font(.font13)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
        )
    }

    var creatorColumn: DataTableColumn<PlaylistTableRow> {
        DataTableColumn(
            id: "creator",
            title: "创建者",
            width: .fixed(Layout.creatorWidth),
            content: { row, _ in
                MusicTableRouteLink(
                    title: row.creatorName,
                    route: .user(id: row.playlist.creator.userId)
                )
            }
        )
    }
}

// MARK: - Layout
private extension PlaylistTable {
    enum Layout {
        static let titleMinWidth: CGFloat = 160
        static let songCountWidth: CGFloat = 150
        static let creatorWidth: CGFloat = 150
    }
}

#Preview {
    PlaylistTable(playlists: [.preview, .featuredPreview])
        .padding(20)
        .frame(width: 800)
        .background(Color.surfaceSecondary)
        .environmentObject(PlayerStore())
}

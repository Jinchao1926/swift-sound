//
//  RadioTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/10.
//

import SwiftUI

struct RadioTable: View {
    let radios: [any RadioProviding]

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        MusicTable(
            rows: rows,
            columns: columns,
            onPlaybackAction: handlePlaybackAction
        )
    }
}

private extension RadioTable {
    var rows: [RadioTableRow] {
        radios.map { RadioTableRow(radio: $0, playbackStatus: playbackStatus(for: $0)) }
    }

    var columns: [DataTableColumn<RadioTableRow>] {
        var columns = [titleColumn, creatorColumn]

        if rows.contains(where: { $0.programCount != nil }) {
            columns.append(programCountColumn)
        }

        if rows.contains(where: { $0.playCount != nil }) {
            columns.append(playCountColumn)
        }

        return columns
    }

    func playbackStatus(for radio: any RadioProviding) -> MusicTablePlaybackStatus {
        .notCurrent
//        let songIDs = playerStore.state.songIDsBySource[.playlist(id: playlist.id)]
//            ?? Set(playlist.tracks?.map(\.id) ?? [])
//        guard
//            let currentSongID = playerStore.state.currentSong?.id,
//            songIDs.contains(currentSongID)
//        else {
//            return .notCurrent
//        }
//
//        return playerStore.state.playbackState.isPlaybackActive
//            ? .currentPlaying
//            : .currentPaused
    }

    func handlePlaybackAction(_ action: MusicTablePlaybackAction, row: RadioTableRow) {
//        switch action {
//        case .play:
//            playerStore.send(.play(.source(.playlist(id: row.playlist.id))))
//        case .pause:
//            playerStore.send(.pause)
//        }
    }

    func handleTitleAction(_ action: MusicTableRowAction, radio: any RadioProviding) {
        switch action {
        case .subscribe, .more:
            break
        default:
            break
        }
    }
}

// MARK: - Columns
private extension RadioTable {
    var titleColumn: DataTableColumn<RadioTableRow> {
        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: Layout.titleMinWidth),
            alignment: .leading,
            content: { row, context in
                RadioTableTitleCell(
                    row: row,
                    rowState: row.rowState(in: context),
                    onAction: {
                        handleTitleAction($0, radio: row.radio)
                    }
                )
            }
        )
    }

    var creatorColumn: DataTableColumn<RadioTableRow> {
        DataTableColumn(
            id: "creator",
            title: "主播",
            width: .fixed(Layout.creatorWidth),
            content: { row, _ in
                if let creatorID = row.creatorID {
                    MusicTableRouteLink(
                        title: row.creatorName,
                        route: .user(id: creatorID)
                    )
                } else {
                    Text(row.creatorName)
                        .font(.font13)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                }
            }
        )
    }

    var programCountColumn: DataTableColumn<RadioTableRow> {
        DataTableColumn(
            id: "programCount",
            title: "声音数",
            width: .fixed(Layout.programCountWidth),
            content: { row, _ in
                Text(row.programCount ?? "-")
                    .font(.font13)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
        )
    }

    var playCountColumn: DataTableColumn<RadioTableRow> {
        DataTableColumn(
            id: "playedCount",
            title: "播放量",
            width: .fixed(Layout.playCountWidth),
            content: { row, _ in
                Text(row.playCount ?? "-")
                    .font(.font13)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
        )
    }
}

// MARK: - Layout
private extension RadioTable {
    enum Layout {
        static let titleMinWidth: CGFloat = 160
        static let creatorWidth: CGFloat = 120
        static let programCountWidth: CGFloat = 100
        static let playCountWidth: CGFloat = 100
    }
}

#Preview {
    RadioTable(radios: [Radio.preview, Radio.preview])
        .padding(20)
        .frame(width: 800)
        .background(Color.surfaceSecondary)
}

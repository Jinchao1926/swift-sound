//
//  ProgramTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import SwiftUI

struct ProgramTable: View {
    let programs: [Program]

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        MusicTable(
            rows: rows,
            columns: columns,
            onPlaybackAction: handlePlaybackAction
        )
    }
}

private extension ProgramTable {
    var rows: [ProgramTableRow] {
        programs.map { ProgramTableRow(program: $0, playbackStatus: playbackStatus(for: $0)) }
    }

    var columns: [DataTableColumn<ProgramTableRow>] {
        [titleColumn, playCountColumn, durationColumn]
    }

    func playbackStatus(for program: Program) -> MusicTablePlaybackStatus {
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

    func handlePlaybackAction(_ action: MusicTablePlaybackAction, row: ProgramTableRow) {
//        switch action {
//        case .play:
//            playerStore.send(.play(.source(.playlist(id: row.playlist.id))))
//        case .pause:
//            playerStore.send(.pause)
//        }
    }

    func handleTitleAction(_ action: MusicTableRowAction, program: Program) {
        switch action {
        case .download, .comment, .more:
            break
        default:
            break
        }
    }
}

// MARK: - Columns
private extension ProgramTable {
    var titleColumn: DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: Layout.titleMinWidth),
            alignment: .leading,
            content: { row, context in
                ProgramTableTitleCell(
                    row: row,
                    rowState: row.rowState(in: context),
                    onAction: {
                        handleTitleAction($0, program: row.program)
                    }
                )
            }
        )
    }

    var playCountColumn: DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "playedCount",
            title: "播放量",
            width: .fixed(Layout.playCountWidth),
            content: { row, _ in
                Text(row.playCount)
                    .font(.font13)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
        )
    }

    var durationColumn: DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "duration",
            title: "时长",
            width: .fixed(Layout.durationWidth),
            content: { row, _ in
                Text(row.durationText)
                    .font(.font13)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
        )
    }
}

// MARK: - Layout
private extension ProgramTable {
    enum Layout {
        static let titleMinWidth: CGFloat = 160
        static let playCountWidth: CGFloat = 90
        static let durationWidth: CGFloat = 80
    }
}

#Preview {
    ProgramTable(programs: [.preview])
        .padding(20)
        .frame(width: 800)
        .background(Color.surfaceSecondary)
}

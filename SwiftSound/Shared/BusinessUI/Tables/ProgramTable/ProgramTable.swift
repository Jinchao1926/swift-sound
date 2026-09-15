//
//  ProgramTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import SwiftUI

struct ProgramTable: View {
    let programs: [Program]
    let onSortChange: (Bool) -> Void

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        let playback = ProgramTablePlayback(playerStore: playerStore)
        DataTable(
            rows: rows(using: playback),
            columns: columns(using: playback),
            style: .plain,
            isRowHighlighted: { $0.playbackStatus.isCurrent }
        )
    }
}

private extension ProgramTable {
    func rows(using playback: ProgramTablePlayback) -> [ProgramTableRow] {
        programs.map { playback.row(for: $0) }
    }

    func columns(using playback: ProgramTablePlayback) -> [DataTableColumn<ProgramTableRow>] {
        [
            indexColumn(using: playback),
            ProgramTableColumns.title { action, program in
                playback.handleTitleAction(action, for: program)
            },
            ProgramTableColumns.updateDate,
            ProgramTableColumns.playCount,
            ProgramTableColumns.duration
        ]
    }

    func indexColumn(
        using playback: ProgramTablePlayback
    ) -> DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "index",
            title: "#",
            width: .fixed(Layout.indexWidth),
            alignment: .center,
            onSort: handleSort,
            content: { row, context in
                MusicTableIndexCell(
                    index: row.program.serialNum,
                    rowState: row.rowState(in: context)
                ) {
                    let action: MusicTablePlaybackAction = row.playbackStatus.isPlaying
                        ? .pause
                        : .play
                    playback.handlePlaybackAction(action, for: row)
                }
            }
        )
    }

    func handleSort(_ order: DataTableSortOrder?) {
        switch order {
        case .ascending:
            onSortChange(true)
        case .descending, .none:
            onSortChange(false)
        }
    }

    enum Layout {
        static let indexWidth: CGFloat = 54
    }
}

#Preview {
    ProgramTable(programs: [.preview], onSortChange: { _ in })
        .padding(20)
        .frame(width: 700)
        .background(Color.surfaceSecondary)
        .environmentObject(PlayerStore())
}

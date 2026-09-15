//
//  ProgramChartTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/14.
//

import SwiftUI

struct ProgramChartTable: View {
    let charts: [ProgramChart]

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        let playback = ProgramTablePlayback(playerStore: playerStore)
        MusicTable(
            rows: rows(using: playback),
            columns: columns(using: playback),
            onPlaybackAction: handlePlaybackAction
        )
    }
}

private extension ProgramChartTable {
    func rows(using playback: ProgramTablePlayback) -> [ProgramTableRow] {
        charts.map {
            playback.row(
                for: $0.program,
                rankingInfo: $0
            )
        }
    }

    func columns(using playback: ProgramTablePlayback) -> [DataTableColumn<ProgramTableRow>] {
        [
            ProgramTableColumns.title { action, program in
                playback.handleTitleAction(action, for: program)
            },
            ProgramTableColumns.playCount,
            ProgramTableColumns.duration
        ]
    }

    func handlePlaybackAction(
        _ action: MusicTablePlaybackAction,
        row: ProgramTableRow
    ) {
        ProgramTablePlayback(playerStore: playerStore)
            .handlePlaybackAction(action, for: row)
    }
}

#Preview {
    ProgramChartTable(charts: [.preview])
        .padding(20)
        .frame(width: 700)
        .background(Color.surfaceSecondary)
        .environmentObject(PlayerStore())
}

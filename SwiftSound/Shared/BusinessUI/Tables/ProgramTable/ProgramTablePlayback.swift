//
//  ProgramTablePlayback.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/14.
//

import Foundation

struct ProgramTablePlayback {
    let playerStore: PlayerStore

    func row(
        for program: Program,
        rankingInfo: (any RankingInfoProviding)? = nil
    ) -> ProgramTableRow {
        ProgramTableRow(
            program: program,
            rankingInfo: rankingInfo,
            playbackStatus: status(for: program)
        )
    }

    func status(for program: Program) -> MusicTablePlaybackStatus {
        .notCurrent
    }

    func handlePlaybackAction(
        _ action: MusicTablePlaybackAction,
        for row: ProgramTableRow
    ) {
    }

    func handleTitleAction(
        _ action: MusicTableRowAction,
        for program: Program
    ) {
        switch action {
        case .download, .comment, .more:
            break
        default:
            break
        }
    }
}

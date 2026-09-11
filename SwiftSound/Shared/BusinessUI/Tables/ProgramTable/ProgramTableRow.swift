//
//  ProgramTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation
import SwiftUI

struct ProgramTableRow: MusicTableRow {
    let program: Program
    let rankingInfo: (any RankingInfoProviding)?
    let playbackStatus: MusicTablePlaybackStatus

    init(
        program: Program,
        rankingInfo: (any RankingInfoProviding)? = nil,
        playbackStatus: MusicTablePlaybackStatus = .notCurrent
    ) {
        self.program = program
        self.rankingInfo = rankingInfo
        self.playbackStatus = playbackStatus
    }

    var id: Int { program.id }
    var imageURL: URL? { program.imageURL }
    var title: String { program.name }
    var radio: Radio { program.radio }

    var playCount: String { program.listenerCount.formattedCount(threshold: .tenThousand) }
    var durationText: String {
        let seconds = max(program.duration / 1000, 0)
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

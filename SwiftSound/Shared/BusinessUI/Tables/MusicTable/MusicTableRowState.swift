//
//  MusicTableRowState.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

enum MusicTablePlaybackStatus: Equatable {
    case notCurrent
    case currentPaused
    case currentPlaying

    var isCurrent: Bool {
        switch self {
        case .notCurrent:
            return false
        case .currentPaused, .currentPlaying:
            return true
        }
    }

    var isPlaying: Bool {
        self == .currentPlaying
    }
}

struct MusicTableRowState: Equatable {
    let isHovering: Bool
    let playbackStatus: MusicTablePlaybackStatus

    init(
        isHovering: Bool = false,
        playbackStatus: MusicTablePlaybackStatus = .notCurrent
    ) {
        self.isHovering = isHovering
        self.playbackStatus = playbackStatus
    }

    var isCurrent: Bool { playbackStatus.isCurrent }
    var isPlaying: Bool { playbackStatus.isPlaying }
    var showsActions: Bool { isHovering }
    var titleColor: Color { isCurrent ? Color.accentPrimary : Color.textPrimary }
    var titleSuffixColor: Color { Color.textSecondary }
    var subtitleColor: Color { isCurrent ? Color.accentPrimary : Color.textSecondary }
}

extension MusicTableRow {
    func rowState(in context: DataTableRowContext) -> MusicTableRowState {
        MusicTableRowState(
            isHovering: context.isHovering,
            playbackStatus: playbackStatus
        )
    }
}

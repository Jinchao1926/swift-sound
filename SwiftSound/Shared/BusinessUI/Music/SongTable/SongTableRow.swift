//
//  SongTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import Foundation
import SwiftUI

struct SongTableRow: Identifiable {
    let song: Song
    let playbackStatus: SongTablePlaybackStatus

    init(
        song: Song,
        playbackStatus: SongTablePlaybackStatus = .notCurrent
    ) {
        self.song = song
        self.playbackStatus = playbackStatus
    }

    var id: Int { song.id }

    var imageURL: URL? { URL(string: song.album.picUrl) }

    var title: String { song.name }

    var titleSuffix: String? {
        guard !song.aliases.isEmpty else { return nil }
        return "(\(song.aliases[0]))"
    }

    var subTitle: String? { song.artistName }

    var isLiked: Bool { false }

    var durationText: String {
        let seconds = max(song.duration / 1000, 0)
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

enum SongTablePlaybackStatus: Equatable {
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

struct SongTableRowState: Equatable {
    let isHovering: Bool
    let playbackStatus: SongTablePlaybackStatus

    init(
        isHovering: Bool = false,
        playbackStatus: SongTablePlaybackStatus = .notCurrent
    ) {
        self.isHovering = isHovering
        self.playbackStatus = playbackStatus
    }

    var isCurrent: Bool { playbackStatus.isCurrent }
    var isPlaying: Bool { playbackStatus.isPlaying }
    var showsActions: Bool { isHovering }
    var titleColor: Color { isCurrent ? Color.accentPrimary : Color.textPrimary }
    var titleSuffixColor: Color { Color.textSecondary }
    var subTitleColor: Color { isCurrent ? Color.accentPrimary : Color.textSecondary }
}

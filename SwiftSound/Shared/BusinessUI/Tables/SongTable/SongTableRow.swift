//
//  SongTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import Foundation
import SwiftUI

struct SongTableRow: MusicTableRow {
    let song: Song
    let playbackStatus: MusicTablePlaybackStatus

    init(
        song: Song,
        playbackStatus: MusicTablePlaybackStatus = .notCurrent
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

    var isLiked: Bool { false }

    var durationText: String {
        let seconds = max(song.duration / 1000, 0)
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    var popularityValue: Int { song.popularity ?? 0 }
}

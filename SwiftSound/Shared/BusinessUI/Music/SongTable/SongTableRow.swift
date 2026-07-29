//
//  SongTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import Foundation

struct SongTableRow: Identifiable {
    let song: Song

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

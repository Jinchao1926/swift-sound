//
//  PlaylistTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import Foundation
import SwiftUI

struct PlaylistTableRow: MusicTableRow {
    let playlist: Playlist
    let playbackStatus: MusicTablePlaybackStatus

    init(
        playlist: Playlist,
        playbackStatus: MusicTablePlaybackStatus = .notCurrent
    ) {
        self.playlist = playlist
        self.playbackStatus = playbackStatus
    }

    var id: Int { playlist.id }

    var imageURL: URL? { playlist.coverURL }

    var title: String { playlist.name }

    var songCount: String { playlist.trackCount.formattedSongCount() }

    var creatorName: String { playlist.creator.nickname }
}

//
//  SongPlaybackURLProviding.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/3.
//

import Foundation

protocol SongPlaybackURLProviding {
    /// Resolves the playable media URL for a song.
    func fetchSongPlaybackURL(_ id: Song.ID) async throws -> URL?
}

extension SongsRespository: SongPlaybackURLProviding {}

//
//  PlayableSource.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import Foundation

enum PlayableSource: Hashable {
    case playlist(id: Playlist.ID)
    case album(id: Album.ID)
}

protocol PlayableSongsProviding {
    func fetchSongs(for source: PlayableSource) async throws -> [Song]
}

struct PlayableSongsProvider: PlayableSongsProviding {
    private let playlistsRepository: any PlaylistsRepositoryProtocol
    private let albumsRepository: any AlbumsRepositoryProtocol

    init(
        playlistsRepository: PlaylistsRepositoryProtocol = PlaylistsRepository(),
        albumsRepository: AlbumsRepositoryProtocol = AlbumsRepository()
    ) {
        self.playlistsRepository = playlistsRepository
        self.albumsRepository = albumsRepository
    }

    func fetchSongs(for source: PlayableSource) async throws -> [Song] {
        switch source {
        case .playlist(let id):
            return try await playlistsRepository.fetchPlaylistDetail(id).tracks ?? []

        case .album(let id):
            return try await albumsRepository.fetchAlbumDetail(id: id).songs
        }
    }
}

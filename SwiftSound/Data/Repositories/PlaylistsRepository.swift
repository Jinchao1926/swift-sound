//
//  PlaylistsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct PlaylistsRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchTopPlaylists(
        category: String,
        offset: Int = 0,
        limit: Int = 24
    ) async throws -> [Playlist] {
        let request = TopPlaylistsRequest(category: category, offset: offset, limit: limit)
        let response = try await apiClient.request(request)
        return response.playlists
    }

    func fetchPlaylistDetail(_ id: Int) async throws -> Playlist {
        let response = try await apiClient.request(PlaylistDetailRequest(id: id))
        return response.playlist
    }
}

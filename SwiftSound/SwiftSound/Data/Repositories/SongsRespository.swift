//
//  SongsRespository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

struct SongsRespository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchNewSongs(offset: Int = 0, limit: Int = 12) async throws -> [NewSong] {
        let request = PersonalizedNewSongsRequest(offset: offset, limit: limit)
        let response = try await apiClient.request(request)
        return response.result
    }

    func fetchSongDetail(_ id: Int) async throws -> Song? {
        let request = SongsDetailRequest(id: id)
        let response = try await apiClient.request(request)
        return response.songs.first
    }

    func fetchSongPlaybackURL(_ id: Int) async throws -> URL? {
        let request = SongPlaybackURLRequest(id: id)
        let response = try await apiClient.request(request)

        guard let rawURL = response.data.first(where: { $0.id == id })?.url,
              let url = URL(string: rawURL) else {
            return nil
        }

        return url
    }

    func fetchLyric(_ id: Int) async throws -> [LyricLine] {
        let response = try await apiClient.request(LyricRequest(id: id))
        return LyricParser.parse(response.lrc.lyric)
    }
}

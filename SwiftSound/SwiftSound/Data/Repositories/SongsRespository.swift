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
}

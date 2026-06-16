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

    func fetchNewSongs() async throws -> [NewSong] {
        let response = try await apiClient.request(PersonalizedNewSongsRequest())
        return response.result
    }
}

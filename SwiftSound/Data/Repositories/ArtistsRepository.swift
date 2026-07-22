//
//  ArtistsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Foundation

struct ArtistsRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchTopPlaylists(
        type: ArtistType,
        area: ArtistArea,
        offset: Int?,
        limit: Int?,
        initial: Int?
    ) async throws -> [Artist] {
        let request = ArtistListRequest(type: type, area: area, offset: offset, limit: limit, initial: initial)
        let response = try await apiClient.request(request)
        return response.artists
    }
}

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

    func fetchArtistList(
        query: ArtistListQuery,
        offset: Int? = nil
    ) async throws -> ArtistListResponse {
        let request = ArtistListRequest(query: query, offset: offset)
        return try await apiClient.request(request)
    }

    func fetchArtistDetail(id: Int) async throws -> ArtistDetail {
        let response = try await apiClient.request(ArtistDetailRequest(id: id))
        return response.data
    }
}

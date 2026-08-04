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

    func fetchArtistDesc(id: Int) async throws -> ArtistDesc {
        let response = try await apiClient.request(ArtistDescRequest(id: id))
        return ArtistDesc(response: response)
    }

    func fetchArtistPopularSongs(id: Int) async throws -> [Song] {
        let response = try await apiClient.request(ArtistPopularSongsRequest(id: id))
        return response.songs
    }

    func fetchArtistSongs(
        id: Int,
        offset: Int = 0,
        limit: Int = 50
    ) async throws -> ArtistSongsResponse {
        let request = ArtistSongsRequest(id: id, offset: offset, limit: limit)
        return try await apiClient.request(request)
    }

    func fetchArtistAlbums(
        id: Int,
        offset: Int = 0,
        limit: Int = 40
    ) async throws -> ArtistAlbumsResponse {
        let request = ArtistAlbumsRequest(id: id, offset: offset, limit: limit)
        return try await apiClient.request(request)
    }

    func fetchArtistMVs(
        id: Int,
        offset: Int = 0,
        limit: Int = 18
    ) async throws -> ArtistMVsResponse {
        let request = ArtistMVsRequest(id: id, offset: offset, limit: limit)
        return try await apiClient.request(request)
    }
}

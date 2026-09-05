//
//  PlaylistsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

protocol PlaylistsRepositoryProtocol {
    func fetchPlaylistCategories() async throws -> [PlaylistCategoryGroup]
    func fetchTopPlaylists(category: String, offset: Int, limit: Int) async throws -> TopPlaylistsResponse
    func fetchPlaylistDetail(_ id: Int) async throws -> Playlist

    func fetchToplists() async throws -> [Toplist]
    func fetchToplistDetails() async throws -> [Toplist]

    func fetchFeaturedPlaylistTags() async throws -> [FeaturedPlaylistTag]
    func fetchFeaturedPlaylists(category: String?, before: Int?, limit: Int) async throws -> FeaturedPlaylistsResponse

    func fetchPlaylistSubscribers(id: Int, offset: Int, limit: Int) async throws -> PlaylistSubscribersResponse
}

extension PlaylistsRepositoryProtocol {
    func fetchTopPlaylists(category: String, offset: Int = 0, limit: Int = 24) async throws -> TopPlaylistsResponse {
        try await fetchTopPlaylists(category: category, offset: offset, limit: limit)
    }

    func fetchFeaturedPlaylists(
        category: String? = nil,
        before: Int? = nil,
        limit: Int = 24
    ) async throws -> FeaturedPlaylistsResponse {
        try await fetchFeaturedPlaylists(category: category, before: before, limit: limit)
    }

    func fetchPlaylistSubscribers(
        id: Int,
        offset: Int = 0,
        limit: Int = 20
    ) async throws -> PlaylistSubscribersResponse {
        try await fetchPlaylistSubscribers(id: id, offset: offset, limit: limit)
    }
}

struct PlaylistsRepository: PlaylistsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Playlist Category
    func fetchPlaylistCategories() async throws -> [PlaylistCategoryGroup] {
        let response = try await apiClient.request(PlaylistCategoriesRequest())
        return PlaylistCategoryParser.parse(response)
    }

    // MARK: - Playlist
    func fetchTopPlaylists(
        category: String,
        offset: Int = 0,
        limit: Int = 24
    ) async throws -> TopPlaylistsResponse {
        let request = TopPlaylistsRequest(category: category, offset: offset, limit: limit)
        let response = try await apiClient.request(request)
        return response
    }

    func fetchPlaylistDetail(_ id: Int) async throws -> Playlist {
        let response = try await apiClient.request(PlaylistDetailRequest(id: id))
        return response.playlist
    }

    // MARK: - Toplist
    func fetchToplists() async throws -> [Toplist] {
        let response = try await apiClient.request(ToplistsRequest())
        return response.list
    }

    func fetchToplistDetails() async throws -> [Toplist] {
        let response = try await apiClient.request(ToplistDetailsRequest())
        return response.list
    }

    // MARK: - Featured Playlist
    func fetchFeaturedPlaylistTags() async throws -> [FeaturedPlaylistTag] {
        let response = try await apiClient.request(FeaturedPlaylistTagsRequest())
        return response.tags
    }

    func fetchFeaturedPlaylists(
        category: String? = nil,
        before: Int? = nil,
        limit: Int = 24
    ) async throws -> FeaturedPlaylistsResponse {
        let request = FeaturedPlaylistsRequest(category: category, before: before, limit: limit)
        let response = try await apiClient.request(request)
        return response
    }

    // MARK: - Subscribers
    func fetchPlaylistSubscribers(
        id: Int,
        offset: Int = 0,
        limit: Int = 20
    ) async throws -> PlaylistSubscribersResponse {
        let request = PlaylistSubscribersRequest(id: id, offset: offset, limit: limit)
        return try await apiClient.request(request)
    }
}

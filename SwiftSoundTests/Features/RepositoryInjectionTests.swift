//
//  RepositoryInjectionTests.swift
//  SwiftSoundTests
//

import Foundation
import Testing
@testable import SwiftSound

@MainActor
struct RepositoryInjectionTests {

    @Test
    func featuredPlaylistViewModelLoadsPlaylistsFromInjectedRepository() async throws {
        let tags = try JSONFixture.decode(
            FeaturedPlaylistTagsResponse.self,
            from: "Playlists/FeaturedPlaylistTagsResponse.json"
        ).tags
        let response = try JSONFixture.decode(
            FeaturedPlaylistsResponse.self,
            from: "Playlists/FeaturedPlaylistsResponse.json"
        )
        let repository = StubPlaylistsRepository(
            tags: .success(tags),
            playlists: .success(response)
        )
        let viewModel = FeaturedPlaylistViewModel(
            initialCategory: "欧美",
            repository: repository
        )

        await viewModel.loadFeaturedTags()
        await viewModel.loadPlaylists()

        #expect(viewModel.selectedTag?.name == "欧美")
        #expect(viewModel.playlistState.items.count == response.playlists.count)
        #expect(viewModel.playlistState.canLoadMore == response.canLoadMore)
    }

    @Test
    func featuredPlaylistViewModelPublishesInjectedRepositoryFailure() async throws {
        let tags = try JSONFixture.decode(
            FeaturedPlaylistTagsResponse.self,
            from: "Playlists/FeaturedPlaylistTagsResponse.json"
        ).tags
        let repository = StubPlaylistsRepository(
            tags: .success(tags),
            playlists: .failure(StubRepositoryError.unavailable)
        )
        let viewModel = FeaturedPlaylistViewModel(
            initialCategory: "欧美",
            repository: repository
        )

        await viewModel.loadFeaturedTags()
        await viewModel.loadPlaylists()

        guard case let .failed(error) = viewModel.playlistState else {
            Issue.record("Expected playlist state to be failed")
            return
        }
        #expect(error is StubRepositoryError)
    }
}

private struct StubPlaylistsRepository: PlaylistsRepositoryProtocol {
    let tags: Result<[FeaturedPlaylistTag], Error>
    let playlists: Result<FeaturedPlaylistsResponse, Error>

    func fetchPlaylistCategories() async throws -> [PlaylistCategoryGroup] {
        fatalError("Not used by these tests")
    }

    func fetchTopPlaylists(
        category: String,
        offset: Int,
        limit: Int
    ) async throws -> TopPlaylistsResponse {
        fatalError("Not used by these tests")
    }

    func fetchPlaylistDetail(_ id: Int) async throws -> Playlist {
        fatalError("Not used by these tests")
    }

    func fetchToplists() async throws -> [Toplist] {
        fatalError("Not used by these tests")
    }

    func fetchToplistDetails() async throws -> [Toplist] {
        fatalError("Not used by these tests")
    }

    func fetchFeaturedPlaylistTags() async throws -> [FeaturedPlaylistTag] {
        try tags.get()
    }

    func fetchFeaturedPlaylists(
        category: String?,
        before: Int?,
        limit: Int
    ) async throws -> FeaturedPlaylistsResponse {
        try playlists.get()
    }

    func fetchPlaylistSubscribers(
        id: Int,
        offset: Int,
        limit: Int
    ) async throws -> PlaylistSubscribersResponse {
        fatalError("Not used by these tests")
    }
}

private enum StubRepositoryError: Error {
    case unavailable
}

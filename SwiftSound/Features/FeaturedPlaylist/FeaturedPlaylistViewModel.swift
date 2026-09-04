//
//  FeaturedPlaylistViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/19.
//

import Foundation
import Combine

final class FeaturedPlaylistViewModel: ObservableObject {
    @Published var selectedTag: FeaturedPlaylistTag?
    @Published var tagState: Loadable<[FeaturedPlaylistTag]> = .idle
    @Published var playlistState: Loadable<Paginated<Playlist>> = .idle

    private let repository: PlaylistsRepositoryProtocol
    private let initialCategory: String
    private var nextBefore: Int?

    init(
        initialCategory: String,
        repository: PlaylistsRepositoryProtocol = PlaylistsRepository()
    ) {
        self.initialCategory = initialCategory
        self.repository = repository
    }

    // MARK: - Featured Tags
    func loadFeaturedTags() async {
        guard !tagState.isLoadedOrLoading else { return }
        tagState = .loading()

        do {
            let tags = try await repository.fetchFeaturedPlaylistTags()
            tagState = .loaded(tags)
            selectedTag = tags.first { $0.name == initialCategory }
        } catch {
            tagState = .failed(error)
        }
    }

    // MARK: - Featured Playlists
    func loadPlaylists() async {
        let requestTag = selectedTag
        nextBefore = nil
        playlistState = .loading()

        do {
            let response = try await repository.fetchFeaturedPlaylists(category: requestTag?.name)
            guard isCurrentTag(requestTag) else { return }
            nextBefore = response.playlists.last?.updateTime
            playlistState = .loaded(Paginated(response))
        } catch {
            guard isCurrentTag(requestTag) else { return }
            playlistState = .failed(error)
        }
    }

    func loadMorePlaylists() async {
        guard !playlistState.isLoading,
              var page = playlistState.value,
              page.canLoadMore else { return }

        let requestTag = selectedTag
        playlistState = .loading(page)

        do {
            let response = try await repository.fetchFeaturedPlaylists(
                category: requestTag?.name,
                before: nextBefore
            )
            guard isCurrentTag(requestTag) else { return }
            nextBefore = response.playlists.last?.updateTime
            page.append(response)
            playlistState = .loaded(page)
        } catch {
            guard isCurrentTag(requestTag) else { return }
            playlistState = .loaded(page)
        }
    }
}

private extension FeaturedPlaylistViewModel {
    func isCurrentTag(_ requestTag: FeaturedPlaylistTag?) -> Bool {
        !Task.isCancelled && requestTag == selectedTag
    }
}

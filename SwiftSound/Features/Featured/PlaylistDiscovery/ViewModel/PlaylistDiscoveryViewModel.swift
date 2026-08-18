//
//  PlaylistDiscoveryViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/14.
//

import Foundation
import Combine

final class PlaylistDiscoveryViewModel: ObservableObject {
    @Published var selection: PlaylistDiscoverySelection = .recommendation
    @Published private(set) var categoryState: Loadable<[PlaylistCategoryGroup]> = .idle
    @Published private(set) var playlistState: Loadable<Paginated<Playlist>> = .idle

    @Published private(set) var featuredTagState: Loadable<[FeaturedPlaylistTag]> = .idle
    @Published private(set) var featuredPlaylistState: Loadable<Playlist> = .idle

    private let repository: PlaylistsRepository
    private var featuredPlaylistSelection: PlaylistDiscoverySelection?

    var hasFeaturedPlaylist: Bool {
        hasFeaturedPlaylist(for: selection)
    }

    // MARK: - LifeCycle
    init(repository: PlaylistsRepository = PlaylistsRepository()) {
        self.repository = repository
    }

    func load() async {
        async let loadCategory: () = loadCategory()
        async let loadFeaturedTags: () = loadFeaturedTags()
        _ = await (loadCategory, loadFeaturedTags)

        await loadFeaturedPlaylistIfNeeded()
    }

    func loadSelection() async {
        async let loadPlaylists: () = loadPlaylists()
        async let loadFeaturedPlaylists: () = loadFeaturedPlaylistIfNeeded()
        _ = await (loadPlaylists, loadFeaturedPlaylists)
    }

    // MARK: - Category
    func loadCategory() async {
        if categoryState.isLoading { return }
        categoryState = .loading()

        do {
            let shortcutTitles = Set(PlaylistDiscoveryShortcut.all.map(\.title))
            let groups = try await repository.fetchPlaylistCategories()
            let categories = groups.compactMap {
                let subs = $0.subs.filter { !shortcutTitles.contains($0.name) }
                return PlaylistCategoryGroup(id: $0.id, name: $0.name, subs: subs)
            }
            categoryState = .loaded(categories)
        } catch {
            categoryState = .failed(error)
        }
    }

    // MARK: - Playlist
    func loadPlaylists() async {
        let requestSelection = selection
        playlistState = .loading()

        do {
            let response = try await repository.fetchTopPlaylists(category: requestSelection.id)
            guard isCurrentSelection(requestSelection) else { return }
            playlistState = .loaded(Paginated(response))
        } catch {
            guard isCurrentSelection(requestSelection) else { return }
            playlistState = .failed(error)
        }
    }

    func loadMorePlaylists() async {
        let requestSelection = selection
        guard var page = playlistState.value, page.canLoadMore else { return }
        playlistState = .loading(page)

        do {
            let response = try await repository.fetchTopPlaylists(
                category: requestSelection.id,
                offset: page.nextOffset
            )
            guard isCurrentSelection(requestSelection) else { return }
            page.append(response)
            playlistState = .loaded(page)
        } catch {
            guard isCurrentSelection(requestSelection) else { return }
            playlistState = .loaded(page)
        }
    }

    // MARK: - Featured
    private func hasFeaturedPlaylist(for selection: PlaylistDiscoverySelection) -> Bool {
        featuredTagState.items.contains { $0.name == selection.id }
    }

    func loadFeaturedTags() async {
        if featuredTagState.isLoading { return }
        featuredTagState = .loading()

        do {
            let tags = try await repository.fetchFeaturedPlaylistTags()
            featuredTagState = .loaded(tags)
        } catch {
            featuredTagState = .failed(error)
        }
    }

    func loadFeaturedPlaylistIfNeeded() async {
        let requestSelection = selection
        guard hasFeaturedPlaylist(for: requestSelection) else {
            featuredPlaylistSelection = nil
            featuredPlaylistState = .idle
            return
        }

        if featuredPlaylistSelection == requestSelection,
           featuredPlaylistState.isLoadedOrLoading {
            return
        }

        featuredPlaylistSelection = requestSelection
        featuredPlaylistState = .loading()

        do {
            let response = try await repository.fetchFeaturedPlaylists(id: 0, limit: 1)
            guard isCurrentSelection(requestSelection) else { return }

            if let playlist = response.playlists.first {
                featuredPlaylistState = .loaded(playlist)
            } else {
                featuredPlaylistState = .idle
            }
        } catch {
            guard isCurrentSelection(requestSelection) else { return }
            featuredPlaylistState = .failed(error)
        }
    }
}

private extension PlaylistDiscoveryViewModel {
    func isCurrentSelection(_ requestSelection: PlaylistDiscoverySelection) -> Bool {
        !Task.isCancelled && requestSelection == selection
    }
}

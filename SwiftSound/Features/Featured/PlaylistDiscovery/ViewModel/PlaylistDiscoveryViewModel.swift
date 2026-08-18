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

    private let repository: PlaylistsRepository

    // MARK: - LifeCycle
    init(repository: PlaylistsRepository = PlaylistsRepository()) {
        self.repository = repository
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
            guard !Task.isCancelled, requestSelection == selection else { return }
            playlistState = .loaded(Paginated(response))
        } catch {
            guard !Task.isCancelled, requestSelection == selection else { return }
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
            guard !Task.isCancelled, requestSelection == selection else { return }
            page.append(response)
            playlistState = .loaded(page)
        } catch {
            guard !Task.isCancelled, requestSelection == selection else { return }
            playlistState = .loaded(page)
        }
    }
}

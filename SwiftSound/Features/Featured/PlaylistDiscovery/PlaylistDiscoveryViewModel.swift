//
//  PlaylistDiscoveryViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/14.
//

import Foundation
import Combine

final class PlaylistDiscoveryViewModel: ObservableObject {
    @Published private(set) var state: Loadable<[PlaylistCategoryGroup]> = .idle

    private let repository: PlaylistsRepository

    // MARK: - LifeCycle
    init(repository: PlaylistsRepository = PlaylistsRepository()) {
        self.repository = repository
    }

    // MARK: - Load
    func load() async {
        if state.isLoading { return }
        state = .loading()

        do {
            let categories = try await repository.fetchPlaylistCategories()
            state = .loaded(categories)
        } catch {
            state = .failed(error)
        }
    }
}

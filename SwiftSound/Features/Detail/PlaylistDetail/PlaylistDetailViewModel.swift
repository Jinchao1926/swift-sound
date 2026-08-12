//
//  PlaylistDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import Foundation
import Combine

final class PlaylistDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<Playlist> = .idle
    @Published var songSearchText = ""

    private let id: Int
    private let repository: PlaylistsRepository

    // MARK: - LifeCycle
    init(
        id: Int,
        repository: PlaylistsRepository = PlaylistsRepository()
    ) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let playlist = try await repository.fetchPlaylistDetail(id)
            state = .loaded(playlist)
        } catch {
            state = .failed(error)
        }
    }
}

//
//  OfficialPlaylistsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation
import Combine

final class OfficialPlaylistsViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([Playlist])
        case failed(Error)

        var playlists: [Playlist] {
            if case let .loaded(playlists) = self {
                return playlists
            }
            return []
        }
    }

    @Published private(set) var state: State = .idle

    private let repository: PlaylistsRepository

    init(repository: PlaylistsRepository = PlaylistsRepository()) {
        self.repository = repository
    }

    func load() async {
        if case .loading = state { return }
        state = .loading

        do {
            let playlists = try await repository.fetchTopPlaylists(category: "官方", limit: 6)
            debugPrint("playlists: \(playlists)")
            state = .loaded(playlists)
        } catch {
            state = .failed(error)
        }
    }
}

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
//            state = .loaded(playlists)

            let detailedPlaylists = await fetchDetailedPlaylists(for: playlists)
            state = .loaded(detailedPlaylists)
        } catch {
            state = .failed(error)
        }
    }

    private typealias PlaylistDetailResult = (index: Int, playlist: Playlist?)
    private func fetchDetailedPlaylists(for playlists: [Playlist]) async -> [Playlist] {
        guard !playlists.isEmpty else { return [] }

        return await withTaskGroup(of: PlaylistDetailResult.self) { group in
            for (index, playlist) in playlists.enumerated() {
                group.addTask { [repository] in
                    do {
                        return (index, try await repository.fetchPlaylistDetail(playlist.id))
                    } catch {
                        return (index, nil)
                    }
                }
            }

            var copied = playlists
            for await (index, playlist) in group {
                if let playlist {
                    copied[index] = playlist
                }
            }

            return copied
        }
    }
}

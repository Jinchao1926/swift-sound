//
//  NewMusicSectionViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation
import Combine

struct NewSongsGroup: Identifiable {
    let id: Int
    let songs: [NewSong]
}

final class NewMusicSectionViewModel: ObservableObject {
    @Published private(set) var state: Loadable<[NewSongsGroup]> = .idle

    private let repository: SongsRepositoryProtocol

    init(repository: SongsRepositoryProtocol = SongsRespository()) {
        self.repository = repository
    }

    func load() async {
        if state.isLoading { return }
        state = .loading()

        do {
            let songs = try await repository.fetchNewSongs(limit: 12)
            let groups = songs.chunked(into: 3).enumerated().map { index, songs in
                NewSongsGroup(id: index, songs: songs)
            }
            state = .loaded(groups)
        } catch {
            state = .failed(error)
        }
    }
}

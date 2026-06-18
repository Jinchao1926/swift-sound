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
    enum State {
        case idle
        case loading
        case loaded([NewSongsGroup])
        case failed(Error)

        var songGroups: [NewSongsGroup] {
            if case let .loaded(songGroups) = self {
                return songGroups
            }
            return []
        }
    }

    @Published private(set) var state: State = .idle

    private let repository: SongsRespository

    init(repository: SongsRespository = SongsRespository()) {
        self.repository = repository
    }

    func load() async {
        if case .loading = state { return }
        state = .loading

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

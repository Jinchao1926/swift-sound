//
//  NewMusicSectionViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation
import Combine

final class NewMusicSectionViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([NewSong])
        case failed(Error)

        var songs: [NewSong] {
            if case let .loaded(songs) = self {
                return songs
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
            let songs = try await repository.fetchNewSongs()
            state = .loaded(songs)
        } catch {
            state = .failed(error)
        }
    }
}

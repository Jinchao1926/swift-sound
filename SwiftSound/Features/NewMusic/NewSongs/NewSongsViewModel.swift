//
//  NewSongsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import Foundation
import Combine

final class NewSongsViewModel: ObservableObject {
    @Published var selectedType: TopSongsType = .all
    @Published private(set) var state: Loadable<[Song]> = .idle

    private let repository: SongsRespository

    init(repository: SongsRespository = SongsRespository()) {
        self.repository = repository
    }

    func load() async {
        let requestType = selectedType
        state = .loading()

        do {
            let songs = try await repository.fetchTopSongs(type: selectedType)
            guard isCurrentType(requestType) else { return }
            state = .loaded(songs)
        } catch {
            guard isCurrentType(requestType) else { return }
            state = .failed(error)
        }
    }
}

private extension NewSongsViewModel {
    func isCurrentType(_ requestType: TopSongsType) -> Bool {
        !Task.isCancelled && requestType == selectedType
    }
}

//
//  ArtistDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import Foundation
import Combine

final class ArtistDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<ArtistDetail> = .idle

    private let id: Int
    private let repository: ArtistsRepository

    // MARK: - LifeCycle
    init(id: Int, repository: ArtistsRepository = ArtistsRepository()) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        if state.isLoading { return }
        state = .loading()

        do {
            let artist = try await repository.fetchArtistDetail(id: id)
            state = .loaded(artist)
        } catch {
            state = .failed(error)
        }
    }
}

extension Loadable where Value == ArtistDetail {
    var artist: Artist? { value?.artist }

    var user: User? { value?.user }
}

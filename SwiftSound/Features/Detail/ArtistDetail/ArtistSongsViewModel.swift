//
//  ArtistSongsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/31.
//

import Foundation
import Combine

final class ArtistSongsViewModel: ObservableObject {
    @Published private(set) var state: Loadable<Paginated<Song>> = .idle

    private let id: Int
    private let repository: ArtistsRepositoryProtocol

    // MARK: - LifeCycle
    init(id: Int, repository: ArtistsRepositoryProtocol = ArtistsRepository()) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading(state.value)

        do {
            let response = try await repository.fetchArtistSongs(id: id)
            state = .loaded(Paginated(response))
        } catch {
            state = .failed(error)
        }
    }

    func loadMore() async {
        guard !state.isLoading else { return }
        guard var page = state.value, page.canLoadMore else { return }

        state = .loading(page)

        do {
            let response = try await repository.fetchArtistSongs(id: id, offset: page.nextOffset)

            page.append(response)
            state = .loaded(page)
        } catch {
            state = .loaded(page)
        }
    }
}

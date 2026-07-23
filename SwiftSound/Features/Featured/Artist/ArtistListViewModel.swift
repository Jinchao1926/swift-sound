//
//  ArtistListViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Foundation
import Combine

final class ArtistListViewModel: ObservableObject {
    @Published private(set) var state: Loadable<Paginated<Artist>> = .idle

    private let repository: ArtistsRepository
    private var currentQuery: ArtistListQuery?

    init(repository: ArtistsRepository = ArtistsRepository()) {
        self.repository = repository
    }

    func load(
        type: ArtistType,
        area: ArtistArea,
        initial: ArtistInitial? = nil
    ) async {
        guard !state.isLoading else { return }

        let query = ArtistListQuery(type: type, area: area, initial: initial ?? .hot)
        state = .loading

        do {
            let response = try await repository.fetchArtistList(query: query, offset: 0)
            currentQuery = query
            state = .loaded(Paginated(response))
        } catch {
            state = .failed(error)
        }
    }

    func loadMore() async {
        guard !state.isLoading,
              let currentQuery,
              var page = state.value,
              page.canLoadMore else {
            return
        }

        state = .loading

        do {
            let response = try await repository.fetchArtistList(
                query: currentQuery,
                offset: page.nextOffset
            )
            page.append(response)
            state = .loaded(page)
        } catch {
            state = .failed(error)
        }
    }
}

extension Loadable where Value == Paginated<Artist> {
    var artists: [Artist] { value?.items ?? [] }
    var canLoadMore: Bool { value?.canLoadMore ?? false }
}

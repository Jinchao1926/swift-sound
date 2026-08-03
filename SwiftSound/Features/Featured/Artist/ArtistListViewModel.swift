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
    @Published private(set) var currentQuery = ArtistListQuery(
        type: .all,
        area: .all,
        initial: .hot
    )

    private var loadedQuery: ArtistListQuery?
    private var loadTask: Task<Void, Never>?
    private let repository: ArtistsRepository

    // MARK: - LifeCycle
    init(repository: ArtistsRepository = ArtistsRepository()) {
        self.repository = repository
    }

    // MARK: - Load
    func load() async {
        await load(query: currentQuery)
    }

    func loadMore() async {
        guard !state.isLoading else { return }
        guard var page = state.value, page.canLoadMore else { return }
        guard let query = loadedQuery, matchesCurrentQuery(query) else { return }

        state = .loading(page)

        do {
            let response = try await repository.fetchArtistList(
                query: query,
                offset: page.nextOffset
            )

            guard matchesCurrentQuery(query) else { return }

            page.append(response)
            state = .loaded(page)
            loadedQuery = query
        } catch {
            guard matchesCurrentQuery(query) else { return }
            state = .loaded(page)
        }
    }

    // MARK: - Selector
    func selectType(_ type: ArtistType) {
        updateQuery(currentQuery.replacing(type: type))
    }

    func selectArea(_ area: ArtistArea) {
        updateQuery(currentQuery.replacing(area: area))
    }

    func selectInitial(_ initial: ArtistInitial) {
        updateQuery(currentQuery.replacing(initial: initial))
    }

    private func updateQuery(_ query: ArtistListQuery) {
        guard !matchesCurrentQuery(query) else { return }

        currentQuery = query
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.load(query: query)
        }
    }

    private func matchesCurrentQuery(_ query: ArtistListQuery) -> Bool {
        // Async responses may arrive after the user changes filters; ignore results
        // that no longer match the latest selected query.
        query == currentQuery
    }

    private func load(query: ArtistListQuery) async {
        guard loadedQuery != query else { return }
        state = .loading(state.value)

        do {
            let response = try await repository.fetchArtistList(
                query: query,
                offset: 0
            )

            guard !Task.isCancelled else { return }
            guard matchesCurrentQuery(query) else { return }

            state = .loaded(Paginated(response))
            loadedQuery = query
        } catch {
            guard !Task.isCancelled else { return }
            guard matchesCurrentQuery(query) else { return }
            state = .failed(error)
        }
    }
}

private extension ArtistListQuery {
    func replacing(
        type: ArtistType? = nil,
        area: ArtistArea? = nil,
        initial: ArtistInitial? = nil
    ) -> ArtistListQuery {
        ArtistListQuery(
            type: type ?? self.type,
            area: area ?? self.area,
            initial: initial ?? self.initial,
            limit: limit
        )
    }
}

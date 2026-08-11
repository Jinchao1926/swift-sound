//
//  RankingListViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import Foundation
import Combine

final class RankingListViewModel: ObservableObject {
    @Published private(set) var state: Loadable<[RankingSection]> = .idle

    private let repository: PlaylistsRepository

    init(repository: PlaylistsRepository = PlaylistsRepository()) {
        self.repository = repository
    }

    func load() async {
        if state.isLoading { return }
        state = .loading()

        do {
            let toplists = try await repository.fetchToplistDetails()
            state = .loaded(makeSections(from: toplists))
        } catch {
            state = .failed(error)
        }
    }
}

private extension RankingListViewModel {
    func makeSections(from toplists: [Toplist]) -> [RankingSection] {
        var toplistsByID = [Int: Toplist](minimumCapacity: toplists.count)
        for toplist in toplists {
            toplistsByID[toplist.id] = toplist
        }

        return RankingCategory.allCases.compactMap { category in
            let toplists = category.toplistIDs.compactMap { toplistsByID[$0] }
            guard !toplists.isEmpty else { return nil }
            return RankingSection(category: category, toplists: toplists)
        }
    }
}

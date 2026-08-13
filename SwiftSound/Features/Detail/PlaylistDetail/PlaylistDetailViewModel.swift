//
//  PlaylistDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import Foundation
import Combine

final class PlaylistDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<Playlist> = .idle
    @Published private(set) var subscriberState: Loadable<Paginated<User>> = .idle
    @Published var songSearchText = ""

    private let id: Int
    private let repository: PlaylistsRepository

    // MARK: - LifeCycle
    init(
        id: Int,
        repository: PlaylistsRepository = PlaylistsRepository()
    ) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let playlist = try await repository.fetchPlaylistDetail(id)
            state = .loaded(playlist)
        } catch {
            state = .failed(error)
        }
    }

    // MARK: - Subscribers
    func loadSubscribers() async {
        guard !subscriberState.isLoadedOrLoading else { return }
        subscriberState = .loading()

        do {
            let response = try await repository.fetchPlaylistSubscribers(id: id)
            subscriberState = .loaded(Paginated(response))
        } catch {
            subscriberState = .failed(error)
        }
    }

    func loadMoreSubscribers() async {
        guard var page = subscriberState.value, page.canLoadMore else { return }
        subscriberState = .loading(page)

        do {
            let response = try await repository.fetchPlaylistSubscribers(id: id, offset: page.nextOffset)
            page.append(response)
            subscriberState = .loaded(page)
        } catch {
            subscriberState = .loaded(page)
        }
    }
}

extension PlaylistDetailViewModel {
    var filteredSongs: [Song] {
        let songs = state.value?.tracks ?? []
        let keyword = songSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else { return songs }

        return songs.filter {
            $0.name.range(
                of: keyword,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil
        }
    }
}

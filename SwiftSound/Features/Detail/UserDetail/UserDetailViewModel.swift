//
//  UserDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<UserDetail> = .idle
    @Published private(set) var playlistState: Loadable<Paginated<Playlist>> = .idle

    private let id: Int
    private let repository: UsersRepository

    // MARK: - LifeCycle
    init(
        id: Int,
        repository: UsersRepository = UsersRepository()
    ) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let user = try await repository.fetchUserDetail(uid: id)
            state = .loaded(user)
        } catch {
            state = .failed(error)
        }
    }

    // MARK: - Playlists
    func loadPlaylists() async {
        guard !playlistState.isLoadedOrLoading else { return }
        playlistState = .loading()

        do {
            let response = try await repository.fetchUserPlaylists(uid: id)
            playlistState = .loaded(Paginated(response))
        } catch {
            playlistState = .failed(error)
        }
    }

    func loadMorePlaylists() async {
        guard var page = playlistState.value, page.canLoadMore else { return }
        playlistState = .loading(page)

        do {
            let response = try await repository.fetchUserPlaylists(uid: id, offset: page.nextOffset)
            page.append(response)
            playlistState = .loaded(page)
        } catch {
            playlistState = .loaded(page)
        }
    }
}

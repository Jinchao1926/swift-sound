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
            let user = try await repository.fetchUserDetail(id: id)
            state = .loaded(user)
        } catch {
            state = .failed(error)
        }
    }
}

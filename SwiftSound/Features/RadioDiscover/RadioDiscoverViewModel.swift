//
//  RadioDiscoverViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import Foundation
import Combine

final class RadioDiscoverViewModel: ObservableObject {
    @Published var state: Loadable<[RadioCategory]> = .idle

    private let repository: RadiosRepositoryProtocol

    init(repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.repository = repository
    }

    // MARK: - Categories
    func loadRadioCategories() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let tags = try await repository.fetchRadioCategories()
            state = .loaded(tags)
        } catch {
            state = .failed(error)
        }
    }

    // MARK: - Radios
}

//
//  RadioDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation
import Combine

final class RadioDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<Radio> = .idle
    @Published var songSearchText = ""

    private let id: Int
    private let repository: RadiosRepositoryProtocol

    init(id: Int, repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let radio = try await repository.fetchRadioDetail(id: id)
            state = .loaded(radio)
        } catch {
            state = .failed(error)
        }
    }
}

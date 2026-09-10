//
//  RadioHostChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Combine

final class RadioHostChartsViewModel: ObservableObject {
    @Published var selectedType: RadioHostChartType = .daily {
        didSet {
            state = cachedStates[selectedType] ?? .idle
        }
    }
    @Published private(set) var state: Loadable<[RadioHostChart]> = .idle

    private var cachedStates: [RadioHostChartType: Loadable<[RadioHostChart]>] = [:]
    private let repository: RadiosRepositoryProtocol

    init(repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.repository = repository
    }

    func load() async {
        let requestType = selectedType

        if let cachedState = cachedStates[requestType] {
            state = cachedState
            return
        }

        guard !state.isLoading else { return }
        state = .loading(state.value)

        do {
            let hosts = try await fetchHosts(for: requestType)
            guard !Task.isCancelled, requestType == selectedType else { return }

            let loadedState = Loadable.loaded(hosts)
            cachedStates[requestType] = loadedState
            state = loadedState
        } catch {
            guard !Task.isCancelled, requestType == selectedType else { return }
            state = .failed(error)
        }
    }
}

private extension RadioHostChartsViewModel {
    func fetchHosts(for type: RadioHostChartType) async throws -> [RadioHostChart] {
        switch type {
        case .daily:
            try await repository.fetchRadioHostChartsDaily()
        case .popular:
            try await repository.fetchRadioHostChartsPopular()
        case .newcomer:
            try await repository.fetchRadioHostChartsNewComer()
        }
    }
}

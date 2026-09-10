//
//  RadioPodcastChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Combine

final class RadioPodcastChartsViewModel: ObservableObject {
    @Published var selectedType: RadioPodcastChartType = .popular {
        didSet {
            state = cachedStates[selectedType] ?? .idle
        }
    }
    @Published private(set) var state: Loadable<[any RadioProviding]> = .idle

    private var cachedStates: [RadioPodcastChartType: Loadable<[any RadioProviding]>] = [:]
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
            let radios = try await fetchRadios(for: requestType)
            guard !Task.isCancelled, requestType == selectedType else { return }

            let loadedState = Loadable.loaded(radios)
            cachedStates[requestType] = loadedState
            state = loadedState
        } catch {
            guard !Task.isCancelled, requestType == selectedType else { return }
            state = .failed(error)
        }
    }
}

private extension RadioPodcastChartsViewModel {
    func fetchRadios(for type: RadioPodcastChartType) async throws -> [any RadioProviding] {
        switch type {
        case .popular:
            try await repository.fetchRadioChartsPopular()
        case .newcomer:
            try await repository.fetchRadioChartsNewComer()
        case .paid:
            try await repository.fetchRadioChartsPaid()
        }
    }
}

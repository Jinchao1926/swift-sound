//
//  RadioProgramChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Combine

final class RadioProgramChartsViewModel: ObservableObject {
    @Published var selectedType: RadioProgramChartType = .daily {
        didSet {
            state = cachedStates[selectedType] ?? .idle
        }
    }
    @Published private(set) var state: Loadable<[ProgramChart]> = .idle

    private var cachedStates: [RadioProgramChartType: Loadable<[ProgramChart]>] = [:]
    private let repository: ProgramsRepositoryProtocol

    init(repository: ProgramsRepositoryProtocol = ProgramsRepository()) {
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
            let radios = try await fetchProgramss(for: requestType)
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

private extension RadioProgramChartsViewModel {
    func fetchProgramss(for type: RadioProgramChartType) async throws -> [ProgramChart] {
        switch type {
        case .daily:
            try await repository.fetchProgramsChartsDaily()
        case .featured:
            try await repository.fetchProgramsChartsFeatured()
        }
    }
}

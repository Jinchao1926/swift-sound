//
//  RadioProgramChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Combine

final class RadioProgramChartsViewModel: ObservableObject {
    @Published var selectedType: RadioProgramChartType = .daily

    let repository: RadiosRepositoryProtocol

    init(repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.repository = repository
    }
}

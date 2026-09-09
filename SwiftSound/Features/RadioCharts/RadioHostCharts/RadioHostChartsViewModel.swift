//
//  RadioHostChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Combine

final class RadioHostChartsViewModel: ObservableObject {
    @Published var selectedType: RadioHostChartType = .daily

    let repository: RadiosRepositoryProtocol

    init(repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.repository = repository
    }
}

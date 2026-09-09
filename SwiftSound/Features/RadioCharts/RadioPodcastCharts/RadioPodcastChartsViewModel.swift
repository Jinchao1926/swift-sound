//
//  RadioPodcastChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Combine

final class RadioPodcastChartsViewModel: ObservableObject {
    @Published var selectedType: RadioPodcastChartType = .popular

    let repository: RadiosRepositoryProtocol

    init(repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.repository = repository
    }
}

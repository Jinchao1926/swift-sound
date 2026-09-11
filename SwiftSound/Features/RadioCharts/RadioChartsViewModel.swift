//
//  RadioChartsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/8.
//

import Foundation
import Combine

final class RadioChartsViewModel: ObservableObject {
    @Published var selected: RadioChartType = .program

    let programViewModel: RadioProgramChartsViewModel
    let podcastViewModel: RadioPodcastChartsViewModel
    let hostViewModel: RadioHostChartsViewModel

    init() {
        programViewModel = RadioProgramChartsViewModel()
        podcastViewModel = RadioPodcastChartsViewModel()
        hostViewModel = RadioHostChartsViewModel()
    }
}

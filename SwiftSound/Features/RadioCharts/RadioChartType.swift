//
//  RadioChartType.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/8.
//

import Foundation

enum RadioChartType: String, CaseIterable, Identifiable {
    case program = "声音榜"
    case podcast = "播客榜"
    case host = "主播榜"

    var id: String { self.rawValue }
}

enum RadioProgramChartType: String, CaseIterable, Identifiable, Hashable {
    case daily = "每日榜"
    case featured = "精品榜"

    var id: String { self.rawValue }
}

enum RadioPodcastChartType: String, CaseIterable, Identifiable, Hashable {
    case popular = "热门榜"
    case newcomer = "新晋榜"
    case paid = "付费榜"

    var id: String { self.rawValue }
}

enum RadioHostChartType: String, CaseIterable, Identifiable, Hashable {
    case daily = "每日榜"
    case popular = "热门榜"
    case newcomer = "新人榜"

    var id: String { self.rawValue }
}

//
//  AppRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Foundation

/// App page route definition
enum AppRoute: Identifiable, Hashable, Equatable {
    case featured(sub: FeaturedRoute = .featured)
    case podcast
    case follow
    case favorite
    case played
    case download

    var id: Self { self }

    var title: String {
        switch self {
        case .featured:
            return "精选"
        case .podcast:
            return "播客"
        case .follow:
            return "关注"
        case .favorite:
            return "我喜欢的音乐"
        case .played:
            return "最近播放"
        case .download:
            return "下载管理"
        }
    }

    var systemImage: String {
        switch self {
        case .featured:
            return "music.pages.fill"
        case .podcast:
            return "dot.radiowaves.left.and.right"
        case .follow:
            return "bubble.fill"
        case .favorite:
            return "heart.fill"
        case .played:
            return "clock.fill"
        case .download:
            return "arrow.down.circle.fill"
        }
    }
}

extension AppRoute {
    /// Check whether two routes belong to the same top-level page.
    /// Ignores associated values, only compares the main enum case.
    ///
    /// Example:
    /// - `AppRoute.featured(sub: .featured).matchesTopLevelRoute(.featured(sub: .vip))` → true
    ///
    /// - Parameter route: The target route to compare
    /// - Returns: True if both routes are the same top-level entry
    func matchesTopLevelRoute(_ route: AppRoute) -> Bool {
        switch (self, route) {
        case (.featured, .featured),
             (.podcast, .podcast),
             (.follow, .follow),
             (.favorite, .favorite),
             (.played, .played),
             (.download, .download):
            return true
        default:
            return false
        }
    }
}

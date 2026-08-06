//
//  AppRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Foundation

/// App page route definition
enum AppRoute: Identifiable, Hashable, Equatable {
    // Sidebar routes
    case featured(secondary: FeaturedRoute = .featured)
    case podcast
    case follow
    case favorite
    case played
    case download
    // Others
    case newMusic(secondary: NewMusicRoute = .songs)
    // Details
    case artist(id: Int, secondary: ArtistRoute = .songs)
    case artistSongs(id: Int)
    case album(id: Int, secondary: AlbumRoute = .songs)
    case user(id: Int, secondary: UserRoute = .playlists)
    case mv(id: Int)

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
        case .newMusic:
            return "最新音乐"
        default:
            return ""
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
        default:
            return ""
        }
    }
}

extension AppRoute {
    /// Canonical route for the page shell.
    ///
    /// Full routes preserve secondary tabs for history records.
    /// Canonical routes strip secondary tabs, keeping only data identifying the page shell.
    /// Use this value only with SwiftUI `.id(...)`, not for navigation.
    private var canonicalPageRoute: AppRoute {
        switch self {
        case .featured:
            return .featured()
        case .newMusic:
            return .newMusic()
        case .artist(let id, _):
            return .artist(id: id)
        case .album(let id, _):
            return .album(id: id)
        case .user(let id, _):
            return .user(id: id)
        default:
            return self
        }
    }

    /// Shell identity of the page mapped to the current route.
    ///
    /// Secondary route changes are pushed to global history without modifying the page shell identity.
    /// SwiftUI rebuilds the target page only upon changes to the main page or detail object.
    var pageRouteKey: AppRoute { canonicalPageRoute }

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
        case
            (.featured, .featured),
            (.podcast, .podcast),
            (.follow, .follow),
            (.favorite, .favorite),
            (.played, .played),
            (.download, .download),
            (.newMusic, .newMusic),
            (.artist, .artist),
            (.album, .album),
            (.user, .user):
            return true
        default:
            return false
        }
    }
}

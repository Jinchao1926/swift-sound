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
    case radioDiscover
    case follow
    case favorite
    case played
    case download
    // Others
    case newMusic(secondary: NewMusicRoute = .songs)
    case featuredPlaylist(category: String)
    case radioCategories
    case radioCharts
    // Details
    case artist(id: Int, secondary: ArtistRoute = .songs)
    case artistSongs(id: Int)
    case album(id: Int, secondary: AlbumRoute = .songs)
    case playlist(id: Int, secondary: PlaylistRoute = .songs)
    case user(id: Int, secondary: UserRoute = .playlists)
    case mv(id: Int)
    case radio(id: Int)
    // Settings
    case setting

    var id: Self { self }

    var isValid: Bool {
        switch self {
        case .artist(let id, _),
             .artistSongs(let id),
             .album(let id, _),
             .playlist(let id, _),
             .user(let id, _),
             .mv(let id),
             .radio(let id):
            return id != 0
        default:
            return true
        }
    }

    var title: String {
        switch self {
        case .featured:
            return "精选"
        case .radioDiscover:
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
        case .radioDiscover:
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
    /// Route identity for the page shell.
    ///
    /// The complete route remains the only route enum. This projection removes
    /// secondary-tab values so tab changes can reuse the same shell occurrence.
    var pageRoute: AppRoute {
        switch self {
        case .featured:
            return .featured()
        case .newMusic:
            return .newMusic()
        case .artist(let id, _):
            return .artist(id: id)
        case .album(let id, _):
            return .album(id: id)
        case .playlist(let id, _):
            return .playlist(id: id)
        case .user(let id, _):
            return .user(id: id)
        default:
            return self
        }
    }

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
            (.radio, .radio),
            (.follow, .follow),
            (.favorite, .favorite),
            (.played, .played),
            (.download, .download),
            (.newMusic, .newMusic),
            (.artist, .artist),
            (.playlist, .playlist),
            (.album, .album),
            (.user, .user):
            return true
        default:
            return false
        }
    }
}

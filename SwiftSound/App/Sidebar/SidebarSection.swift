//
//  SidebarSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Foundation

enum SidebarSection: CaseIterable, Identifiable {
    case discover
    case library
    case createdPlaylist
//    case favoritedPlaylist

    var id: Self { self }

    var routes: [AppRoute] {
        switch self {
        case .discover:
            return [.featured(), .podcast, .follow]
        case .library:
            return [.favorite, .played, .download]
        case .createdPlaylist:
            return []
//        case .favoritedPlaylist:
//            return []
        }
    }
}

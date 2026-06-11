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

    var id: Self { self }

    var title: String {
        switch self {
        case .discover:
            return "Discover"
        case .library:
            return "Library"
        }
    }

    var routes: [HomeRoute] {
        switch self {
        case .discover:
            return [.featured, .podcast, .follow]
        case .library:
            return [.favorite, .played, .download]
        }
    }
}

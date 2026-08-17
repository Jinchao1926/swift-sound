//
//  PlaylistDiscoveryCategory.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/14.
//

import Foundation

enum PlaylistDiscoverySelection: Hashable {
    case recommendation
    case official
    case category(PlaylistCategory.ID)

    var id: String {
        switch self {
        case .recommendation:
            return "recommendation"
        case .official:
            return "official"
        case .category(let categoryID):
            return categoryID
        }
    }

    var categoryID: PlaylistCategory.ID? {
        guard case .category(let categoryID) = self else { return nil }
        return categoryID
    }
}

struct PlaylistDiscoveryShortcut: Identifiable, Hashable {
    let title: String
    let selection: PlaylistDiscoverySelection

    var id: String { selection.id }

    static let all: [Self] = [
        Self(title: "推荐", selection: .recommendation),
        Self(title: "官方", selection: .official),
        Self(title: "华语", selection: .category("华语")),
        Self(title: "摇滚", selection: .category("摇滚")),
        Self(title: "民谣", selection: .category("民谣")),
        Self(title: "电子", selection: .category("电子")),
        Self(title: "轻音乐", selection: .category("轻音乐"))
    ]
}

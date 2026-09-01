//
//  PlaylistTableAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import Foundation

enum PlaylistTableAction: CaseIterable, Hashable {
    case favorite
    case more

    static var items: [MusicTableActionItem<Self>] {
        allCases.map(\.item)
    }

    private var item: MusicTableActionItem<Self> {
        switch self {
        case .favorite:
            MusicTableActionItem(action: self, systemName: "plus.square", title: "收藏")
        case .more:
            MusicTableActionItem(action: self, systemName: "ellipsis", title: "更多")
        }
    }
}

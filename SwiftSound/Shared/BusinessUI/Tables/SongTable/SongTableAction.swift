//
//  SongTableAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import Foundation

enum SongTableAction: CaseIterable, Hashable {
    case download
    case addToPlaylist
    case comment
    case more

    static var items: [MusicTableActionItem<Self>] {
        allCases.map(\.item)
    }

    private var item: MusicTableActionItem<Self> {
        switch self {
        case .download:
            MusicTableActionItem(action: self, systemName: "arrow.down.circle", title: "下载")
        case .addToPlaylist:
            MusicTableActionItem(action: self, systemName: "plus.square", title: "收藏")
        case .comment:
            MusicTableActionItem(action: self, systemName: "text.bubble", title: "评论")
        case .more:
            MusicTableActionItem(action: self, systemName: "ellipsis", title: "更多")
        }
    }
}

//
//  MusicTableActionView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

enum MusicTableRowAction: Hashable, Identifiable {
    case subscribe
    case download
    case addToPlaylist
    case comment
    case more

    var id: Self { self }

    var systemName: String {
        switch self {
        case .subscribe:
            "plus.square"
        case .download:
            "arrow.down.circle"
        case .addToPlaylist:
            "plus.square"
        case .comment:
            "text.bubble"
        case .more:
            "ellipsis"
        }
    }

    var title: String {
        switch self {
        case .subscribe:
            "收藏"
        case .download:
            "下载"
        case .addToPlaylist:
            "收藏"
        case .comment:
            "评论"
        case .more:
            "更多"
        }
    }
}

struct MusicTableActionView: View {
    let items: [MusicTableRowAction]
    let onAction: (MusicTableRowAction) -> Void

    var body: some View {
        HStack(spacing: Layout.actionSpacing) {
            ForEach(items) { item in
                IconButton(
                    systemName: item.systemName,
                    font: .font16,
                    size: Layout.actionSize
                ) {
                    onAction(item)
                }
                .help(item.title)
                .accessibilityLabel(item.title)
            }
        }
        .layoutPriority(1)
    }
}

private enum Layout {
    static let actionSpacing: CGFloat = 12
    static let actionSize: CGFloat = 18
}

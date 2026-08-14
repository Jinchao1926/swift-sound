//
//  MusicActionButtons.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/13.
//

import SwiftUI

enum MusicActionButtons {
    enum DownloadIcon {
        case arrowDownSquare
        case squareAndArrowDown

        var systemName: String {
            switch self {
            case .arrowDownSquare:
                "arrow.down.square.fill"
            case .squareAndArrowDown:
                "square.and.arrow.down.fill"
            }
        }
    }

    static func playAll(action: @escaping () -> Void) -> some View {
        ActionButton(
            "播放全部",
            systemName: "play.fill",
            variant: .primary,
            action: action
        )
    }

    static func favorite(
        _ title: String = "收藏",
        action: @escaping () -> Void
    ) -> some View {
        secondaryButton(title, systemName: "plus.square.fill", action: action)
    }

    static func follow(
        _ title: String = "关注",
        action: @escaping () -> Void
    ) -> some View {
        secondaryButton(title, systemName: "plus", action: action)
    }

    static func download(
        icon: DownloadIcon = .arrowDownSquare,
        action: @escaping () -> Void
    ) -> some View {
        secondaryButton("下载", systemName: icon.systemName, action: action)
    }

    static func more(action: @escaping () -> Void) -> some View {
        ActionButton(systemName: "ellipsis", action: action)
    }
}

private extension MusicActionButtons {
    static func secondaryButton(
        _ title: String,
        systemName: String,
        action: @escaping () -> Void
    ) -> some View {
        ActionButton(
            title,
            systemName: systemName,
            variant: .secondary,
            action: action
        )
    }
}

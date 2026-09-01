//
//  MusicTableActionView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

struct MusicTableActionItem<Action: Hashable>: Identifiable {
    let action: Action
    let systemName: String
    let title: String

    var id: Action { action }
}

struct MusicTableActionView<Action: Hashable>: View {
    let items: [MusicTableActionItem<Action>]
    let onAction: (Action) -> Void

    var body: some View {
        HStack(spacing: Layout.actionSpacing) {
            ForEach(items) { item in
                IconButton(
                    systemName: item.systemName,
                    font: .font16,
                    size: Layout.actionSize
                ) {
                    onAction(item.action)
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

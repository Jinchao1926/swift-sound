//
//  UserPlaylistTabView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/31.
//

import SwiftUI

enum PlaylistTab: CaseIterable, Hashable, Identifiable {
    case created
    case favorite

    var id: Self { self }

    var title: String {
        switch self {
        case .created: "创建"
        case .favorite: "收藏"
        }
    }
}

struct UserPlaylistTabView: View {
    let selectedTab: PlaylistTab
    let onSelect: (PlaylistTab) -> Void

    var body: some View {
        HStack(spacing: Layout.tabSpacing) {
            ForEach(PlaylistTab.allCases) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    Text(tab.title)
                        .font(.font14.weight(.medium))
                        .foregroundStyle(tab == selectedTab ? Color.textPrimary : Color.textSecondary)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .pointerStyle(.link)
            }
        }
    }
}

private extension UserPlaylistTabView {
    enum Layout {
        static let tabSpacing: CGFloat = 20
    }
}

#Preview {
    @Previewable @State var selectedTab = PlaylistTab.created

    UserPlaylistTabView(selectedTab: selectedTab) { tab in
        selectedTab = tab
    }
    .padding()
}

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

struct PlaylistSelection: Equatable {
    enum Action {
        case tab(PlaylistTab)
        case displayMode(DisplayMode)
    }

    private(set) var tab = PlaylistTab.created
    private var displayModesByTab: [PlaylistTab: DisplayMode] = [:]

    var displayMode: DisplayMode {
        displayModesByTab[tab] ?? .grid
    }

    mutating func apply(_ action: Action) {
        switch action {
        case .tab(let tab):
            self.tab = tab
        case .displayMode(let displayMode):
            displayModesByTab[tab] = displayMode
        }
    }
}

struct UserPlaylistTabView: View {
    let selection: PlaylistSelection
    let onAction: (PlaylistSelection.Action) -> Void

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: Layout.tabSpacing) {
                ForEach(PlaylistTab.allCases) { tab in
                    Button {
                        onAction(.tab(tab))
                    } label: {
                        Text(tab.title)
                            .font(.font14.weight(.medium))
                            .foregroundStyle(tab == selection.tab ? Color.textPrimary : Color.textSecondary)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .pointerStyle(.link)
                }
            }

            Spacer()

            DisplayModePicker(selection: selection.displayMode) {
                onAction(.displayMode($0))
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
    @Previewable @State var selection = PlaylistSelection()

    UserPlaylistTabView(selection: selection) { change in
        selection.apply(change)
    }
    .frame(width: 400)
    .padding()
}

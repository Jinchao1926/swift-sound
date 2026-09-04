//
//  UserRadioSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/3.
//
import SwiftUI

struct UserRadioSection: View {
    let state: Loadable<Paginated<Radio>>
    let displayMode: DisplayMode

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.paginationSpacing) {
            Group {
                if state.value != nil, state.items.isEmpty {
                    EmptyStateView()
                } else {
                    radios(state.items)
                }
            }
            .loadingPlaceholder(state.isInitialLoading)
        }
    }

    @ViewBuilder
    private func radios(_ radios: [Radio]) -> some View {
        switch displayMode {
        case .grid:
            playlistsGrid(radios)
        case .list:
            // TODO: RadioTable
            EmptyView()
        }
    }

    private func playlistsGrid(_ radios: [Radio]) -> some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: Layout.minCardWidth),
                    spacing: Layout.columnSpacing,
                    alignment: .top
                )
            ],
            alignment: .leading,
            spacing: Layout.rowSpacing
        ) {
            ForEach(radios) { radio in
                UserRadioCard(radio: radio) {}
//                    .routeLink(to: .playlist(id: playlist.id))
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private extension UserRadioSection {
    enum Layout {
        static let minCardWidth: CGFloat = 176
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20
        static let paginationSpacing: CGFloat = 6
    }
}

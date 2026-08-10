//
//  ArtistMVsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/24.
//

import SwiftUI

struct ArtistMVsPage: View {
    let state: Loadable<Paginated<MV>>
    let load: () async -> Void
    let loadMore: () async -> Void

    var body: some View {
        LazyVGrid(
            columns: Layout.gridColumns,
            alignment: .leading,
            spacing: Layout.gridSpacing
        ) {
            Section {
                ForEach(state.items) { mv in
                    MVCard(mv: mv)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .routeLink(to: .mv(id: mv.id))
                }
            } footer: {
                if state.value != nil {
                    InfiniteScrollFooter(
                        canLoadMore: state.canLoadMore,
                        isLoading: state.isLoading,
                        loadKey: state.items.count
                    ) {
                        await loadMore()
                    }
                }
            }
        }
        .loadingPlaceholder(state.isInitialLoading)
        .padding(.top, Layout.contentTopPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await load()
        }
    }
}

private extension ArtistMVsPage {
    enum Layout {
        static let minimumCardWidth: CGFloat = 240
        static let gridSpacing: CGFloat = 15
        static let contentTopPadding: CGFloat = 5

        static let gridColumns: [GridItem] = [
            GridItem(.adaptive(minimum: minimumCardWidth), spacing: gridSpacing, alignment: .top)
        ]
    }
}

#Preview {
    VStack {
        ArtistMVsPage(
            state: .loaded(Paginated(items: [MV.preview], canLoadMore: true)),
            load: {},
            loadMore: {},
        )
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding(.horizontal, 40)
}

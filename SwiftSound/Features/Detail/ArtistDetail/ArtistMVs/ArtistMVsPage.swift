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
        PaginatedGridView(
            state: state,
            minItemWidth: Layout.minItemWidth,
            columnSpacing: Layout.columnSpacing,
            rowSpacing: Layout.rowSpacing,
            loadMore: loadMore
        ) {
            ForEach(state.items) { mv in
                MVCard(mv: mv)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .routeLink(to: .mv(id: mv.id))
            }
        }
        .padding(.top, Layout.contentTopInset)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .loadable(state: state, retry: load)
        .task {
            await load()
        }
    }
}

private extension ArtistMVsPage {
    enum Layout {
        static let minItemWidth: CGFloat = 240
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20
        static let contentTopInset: CGFloat = 5
    }
}

#Preview {
    ArtistMVsPage(
        state: .loaded(Paginated(items: [MV.preview], canLoadMore: true)),
        load: {},
        loadMore: {},
    )
    .frame(minWidth: 600, minHeight: 600)
    .padding(.horizontal, 40)
}

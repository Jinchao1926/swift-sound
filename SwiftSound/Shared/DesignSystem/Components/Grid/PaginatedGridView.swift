//
//  PaginatedGridView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

struct PaginatedGridView<Page: PaginatedValue, Content: View>: View {
    let state: Loadable<Page>
    let minItemWidth: CGFloat
    let columnSpacing: CGFloat
    let rowSpacing: CGFloat
    let itemAlignment: Alignment
    let loadMore: (() async -> Void)?
    let content: () -> Content

    init(
        state: Loadable<Page>,
        minItemWidth: CGFloat = 176,
        columnSpacing: CGFloat = 20,
        rowSpacing: CGFloat = 20,
        itemAlignment: Alignment = .top,
        loadMore: (() async -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.minItemWidth = minItemWidth
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.itemAlignment = itemAlignment
        self.loadMore = loadMore
        self.content = content
    }

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: minItemWidth),
                    spacing: columnSpacing,
                    alignment: itemAlignment
                )
            ],
            alignment: .leading,
            spacing: rowSpacing
        ) {
            Section {
                content()
            } footer: {
                if let loadMore {
                    InfiniteScrollFooter(
                        state: state,
                        onLoadMore: loadMore
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

//
//  PlaylistSubscribersPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import SwiftUI

struct PlaylistSubscribersPage: View {
    let state: Loadable<Paginated<User>>
    let load: () async -> Void
    let loadMore: () async -> Void

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: Layout.minCardWidth),
                    spacing: Layout.rowSpacing,
                    alignment: .top
                )
            ],
            alignment: .leading,
            spacing: Layout.columnSpacing
        ) {
            Section {
                ForEach(state.items) {
                    SubscriberCard(user: $0)
                        .routeLink(to: .user(id: $0.id))
                }
            } footer: {
                InfiniteScrollFooter(state: state) {
                    await loadMore()
                }
            }
        }
        .padding(.top, Layout.contentTopInset)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .loadingPlaceholder(state.isInitialLoading)
        .task {
            await load()
        }
    }
}

private extension PlaylistSubscribersPage {
    enum Layout {
        static let minCardWidth: CGFloat = 176
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20
        static let contentTopInset: CGFloat = 10
    }
}

#Preview {
    PlaylistSubscribersPage(
        state: .loaded(Paginated(items: [User.preview], canLoadMore: true)),
        load: {},
        loadMore: {}
    )
    .frame(minWidth: 600, minHeight: 600)
    .padding(.horizontal, 40)
}

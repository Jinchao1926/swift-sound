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
            columns: Layout.gridColumns,
            alignment: .leading,
            spacing: Layout.gridSpacing
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
        .padding(.top, Layout.contentTopPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .loadingPlaceholder(state.isInitialLoading)
        .task {
            await load()
        }
    }
}

private extension PlaylistSubscribersPage {
    enum Layout {
        static let minimumCardWidth: CGFloat = 180
        static let gridSpacing: CGFloat = 10
        static let contentTopPadding: CGFloat = 10

        static let gridColumns: [GridItem] = [
            GridItem(.adaptive(minimum: minimumCardWidth), spacing: gridSpacing, alignment: .top)
        ]
    }
}

#Preview {
    VStack {
        PlaylistSubscribersPage(
            state: .loaded(Paginated(items: [User.preview], canLoadMore: true)),
            load: {},
            loadMore: {}
        )
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding(.horizontal, 40)
}

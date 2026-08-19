//
//  ArtistAlbumsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/24.
//

import SwiftUI

struct ArtistAlbumsPage: View {
    let state: Loadable<Paginated<Album>>
    let load: () async -> Void
    let loadMore: () async -> Void
    let onPlayAlbum: (Album.ID) -> Void

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
                ForEach(state.items) { album in
                    AlbumCard(album: album) {
                        onPlayAlbum(album.id)
                    }
                    .routeLink(to: .album(id: album.id))
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

private extension ArtistAlbumsPage {
    enum Layout {
        static let minCardWidth: CGFloat = 176
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20
        static let contentTopInset: CGFloat = 20
    }
}

#Preview {
    VStack {
        ArtistAlbumsPage(
            state: .loaded(Paginated(items: [Album.preview], canLoadMore: true)),
            load: {},
            loadMore: {},
            onPlayAlbum: { _ in }
        )
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding(.horizontal, 40)
}

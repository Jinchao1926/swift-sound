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
    let playAlbum: (Album.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LazyVGrid(
                columns: Layout.gridColumns,
                alignment: .leading,
                spacing: Layout.gridSpacing
            ) {
                Section {
                    ForEach(state.albums) { album in
                        AlbumCard(album: album) {
                            playAlbum(album.id)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .routeLink(to: .album(id: album.id))
                    }
                } footer: {
                    if state.value != nil {
                        InfiniteScrollFooter(
                            canLoadMore: state.canLoadMore,
                            isLoading: state.isLoading,
                            loadKey: state.albums.count
                        ) {
                            await loadMore()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.top, Layout.contentTopPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await load()
        }
    }
}

private extension ArtistAlbumsPage {
    enum Layout {
        static let minimumCardWidth: CGFloat = 178
        static let gridSpacing: CGFloat = 10
        static let contentTopPadding: CGFloat = 20

        static let gridColumns: [GridItem] = [
            GridItem(.adaptive(minimum: minimumCardWidth), spacing: gridSpacing, alignment: .top)
        ]
    }
}

extension Loadable where Value == Paginated<Album> {
    var albums: [Album] { value?.items ?? [] }
    var canLoadMore: Bool { value?.canLoadMore ?? false }
}

#Preview {
    VStack {
        ArtistAlbumsPage(
            state: .loaded(Paginated(items: [Album.preview], canLoadMore: true)),
            load: {},
            loadMore: {},
            playAlbum: { _ in }
        )
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding(.horizontal, 40)
}

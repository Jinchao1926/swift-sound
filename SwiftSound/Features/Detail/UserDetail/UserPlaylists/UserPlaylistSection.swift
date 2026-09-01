//
//  UserPlaylistSection.swift
//  SwiftSound
//

import SwiftUI

struct UserPlaylistSection: View {
    let collection: UserDetailViewModel.PlaylistCollection
    let onPageChange: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.paginationSpacing) {
            if collection.state.value != nil, collection.state.items.isEmpty {
                EmptyStateView()
            } else {
                playlistsGrid(collection.state.items)
                    .loadingPlaceholder(collection.state.isInitialLoading)
            }

            if collection.pageCount > 1 {
                PaginationControl(
                    currentPage: Binding(
                        get: { collection.currentPage },
                        set: onPageChange
                    ),
                    pageCount: collection.pageCount,
                    isEnabled: !collection.state.isLoading
                )
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func playlistsGrid(_ playlists: [Playlist]) -> some View {
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
            ForEach(playlists) { playlist in
                UserPlaylistCard(playlist: playlist) {}
                    .routeLink(to: .playlist(id: playlist.id))
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private extension UserPlaylistSection {
    enum Layout {
        static let minCardWidth: CGFloat = 176
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20
        static let paginationSpacing: CGFloat = 6
    }
}

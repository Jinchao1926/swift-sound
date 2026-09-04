//
//  UserPlaylistSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

struct UserPlaylistSection: View {
    let collection: UserDetailViewModel.PlaylistCollection
    let displayMode: DisplayMode
    let onPageChange: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.paginationSpacing) {
            playlists(collection.state.items)
                .loadable(state: collection.state)

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

    @ViewBuilder
    private func playlists(_ playlists: [Playlist]) -> some View {
        switch displayMode {
        case .grid:
            playlistsGrid(playlists)
        case .list:
            PlaylistTable(playlists: playlists)
        }
    }

    private func playlistsGrid(_ playlists: [Playlist]) -> some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: Layout.minItemWidth),
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
        static let minItemWidth: CGFloat = 176
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20
        static let paginationSpacing: CGFloat = 6
    }
}

//
//  UserPlaylistSection.swift
//  SwiftSound
//

import SwiftUI

struct UserPlaylistSection: View {
    let title: String
    let collection: UserDetailViewModel.PlaylistCollection
    let onPageChange: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.titleSpacing) {
            Text(title)
                .font(.font18.weight(.semibold))
                .foregroundStyle(Color.textPrimary)

            playlistsGrid(collection.state.items)
                .loadingPlaceholder(collection.state.isLoading)

            if collection.pageCount > 1 {
                PaginationControl(
                    currentPage: Binding(
                        get: { collection.currentPage },
                        set: onPageChange
                    ),
                    pageCount: collection.pageCount,
                    isEnabled: !collection.state.isLoading
                )
                .padding(.top, Layout.paginationTopPadding)
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
        static let titleSpacing: CGFloat = 12
        static let paginationTopPadding: CGFloat = 6
    }
}

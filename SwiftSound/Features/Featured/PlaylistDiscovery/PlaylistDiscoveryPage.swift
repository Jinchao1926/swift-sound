//
//  PlaylistDiscoveryPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct PlaylistDiscoveryPage: View {
    @StateObject private var viewModel = PlaylistDiscoveryViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.contentSpacing) {
            PlaylistDiscoveryCategoryBar(
                categoryGroups: viewModel.categoryState.value ?? [],
                selection: $viewModel.selection
            )

            PaginatedGridView(
                state: viewModel.playlistState,
                minItemWidth: Layout.minItemWidth,
                columnSpacing: Layout.columnSpacing,
                rowSpacing: Layout.rowSpacing,
                loadMore: viewModel.loadMorePlaylists
            ) {
                if viewModel.hasFeaturedPlaylist {
                    FeaturedPlaylistEntry(playlist: viewModel.featuredPlaylistState.value)
                        .routeLink(to: .featuredPlaylist(category: viewModel.selection.id))
                }

                ForEach(viewModel.playlistState.items) {
                    PlaylistDiscoveryCard(playlist: $0) {
                        // ...
                    }
                    .routeLink(to: .playlist(id: $0.id))
                }
            }
            .loadingPlaceholder(viewModel.playlistState.isInitialLoading)
        }
        .padding(.horizontal, Layout.horizontalInset)
        .padding(.top, Layout.topInset)
        .task {
            await viewModel.load()
        }
        .task(id: viewModel.selection) {
            await viewModel.loadSelection()
        }
    }
}

private extension PlaylistDiscoveryPage {
    enum Layout {
        static let topInset: CGFloat = 3
        static let horizontalInset: CGFloat = 40
        static let contentSpacing: CGFloat = 25

        static let minItemWidth: CGFloat = 115
        static let columnSpacing: CGFloat = 15
        static let rowSpacing: CGFloat = 15
    }
}

#Preview {
    ScrollView {
        PlaylistDiscoveryPage()
    }
    .frame(width: 800, height: 600)
    .padding()
}

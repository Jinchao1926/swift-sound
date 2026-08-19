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

            LazyVGrid(
                columns: Layout.gridColumns,
                alignment: .leading,
                spacing: Layout.gridSpacing
            ) {
                Section {
                    if viewModel.hasFeaturedPlaylist {
                        FeaturedPlaylistEntry(playlist: viewModel.featuredPlaylistState.value)
                            .routeLink(to: .featuredPlaylist)
                    }

                    ForEach(viewModel.playlistState.items) {
                        PlaylistDiscoveryCard(playlist: $0) {
                            // ...
                        }
                        .routeLink(to: .playlist(id: $0.id))
                    }
                } footer: {
                    if viewModel.playlistState.value != nil {
                        InfiniteScrollFooter(
                            canLoadMore: viewModel.playlistState.canLoadMore,
                            isLoading: viewModel.playlistState.isLoading,
                            loadKey: viewModel.playlistState.items.count
                        ) {
                            await viewModel.loadMorePlaylists()
                        }
                    }
                }
            }
            .loadingPlaceholder(viewModel.playlistState.isInitialLoading)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.topPadding)
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
        static let topPadding: CGFloat = 3
        static let horizontalPadding: CGFloat = 40
        static let contentSpacing: CGFloat = 25

        static let minimumCardWidth: CGFloat = 116
        static let gridSpacing: CGFloat = 15

        static let gridColumns: [GridItem] = [
            GridItem(.adaptive(minimum: minimumCardWidth), spacing: gridSpacing, alignment: .top)
        ]
    }
}

#Preview {
    ScrollView {
        PlaylistDiscoveryPage()
    }
    .frame(width: 800, height: 600)
    .padding()
}

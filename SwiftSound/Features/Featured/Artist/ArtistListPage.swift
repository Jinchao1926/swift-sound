//
//  ArtistListPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct ArtistListPage: View {
    @StateObject private var viewModel = ArtistListViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ArtistListFilterBar(
                query: viewModel.currentQuery,
                onAreaSelect: viewModel.selectArea,
                onTypeSelect: viewModel.selectType,
                onInitialSelect: viewModel.selectInitial
            )

            VStack(alignment: .leading, spacing: 0) {
                LazyVGrid(
                    columns: Layout.gridColumns,
                    alignment: .leading,
                    spacing: Layout.gridSpacing
                ) {
                    Section {
                        ForEach(viewModel.state.artists) { artist in
                            RouteLink(route: .artist(id: artist.id)) {
                                ArtistCard(artist: artist)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    } footer: {
                        InfiniteScrollFooter(
                            canLoadMore: viewModel.state.canLoadMore,
                            isLoading: viewModel.state.isLoading,
                            loadKey: viewModel.state.artists.count
                        ) {
                            await viewModel.loadMore()
                        }
                    }
                }
            }
            .padding(.top, Layout.contentTopPadding)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await viewModel.load()
        }
    }
}

private extension ArtistListPage {
    enum Layout {
        static let minimumCardWidth: CGFloat = 178
        static let gridSpacing: CGFloat = 20
        static let contentTopPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 40

        static let gridColumns: [GridItem] = [
            GridItem(.adaptive(minimum: minimumCardWidth), spacing: gridSpacing, alignment: .top)
        ]
    }
}

#Preview {
    VStack {
        ArtistListPage()
    }
    .frame(minWidth: 1400, minHeight: 1000)
}

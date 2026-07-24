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
                    columns:
                        [GridItem(.adaptive(minimum: 178), spacing: 20, alignment: .top)],
                    alignment: .leading,
                    spacing: 20
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
            .padding(.top, 20)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    VStack {
        ArtistListPage()
    }
    .frame(minWidth: 1400, minHeight: 1000)
}

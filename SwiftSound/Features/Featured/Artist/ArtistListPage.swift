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
                onAreaSelect: { area in
                    Task { await viewModel.selectArea(area) }
                },
                onTypeSelect: { type in
                    Task { await viewModel.selectType(type) }
                },
                onInitialSelect: { initial in
                    Task { await viewModel.selectInitial(initial) }
                }
            )

            VStack(alignment: .leading, spacing: 0) {
                LazyVGrid(
                    columns:
                        [GridItem(.adaptive(minimum: 178), spacing: 20, alignment: .top)],
                    alignment: .leading,
                    spacing: 20
                ) {
                    ForEach(viewModel.state.artists) { artist in
                        ArtistCover(artist: artist)
                            .frame(maxWidth: .infinity)
                    }
                }

                if viewModel.state.canLoadMore && !viewModel.state.isLoading {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            Task { await viewModel.loadMore() }
                        }
                }

                if viewModel.state.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .controlSize(.small)
                        Spacer()
                    }
                    .padding(.vertical, 20)
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

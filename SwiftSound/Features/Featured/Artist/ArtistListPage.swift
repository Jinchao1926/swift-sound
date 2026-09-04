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

            PaginatedGridView(
                state: viewModel.state,
                minItemWidth: Layout.minItemWidth,
                columnSpacing: Layout.columnSpacing,
                rowSpacing: Layout.rowSpacing,
                loadMore: viewModel.loadMore
            ) {
                ForEach(viewModel.state.items) { artist in
                    ArtistCard(artist: artist)
                        .frame(maxWidth: .infinity)
                        .routeLink(to: .artist(id: artist.id))
                }
            }
            .padding(.top, Layout.contentTopInset)
            .loadingPlaceholder(viewModel.state.isInitialLoading)
        }
        .padding(.horizontal, Layout.horizontalInset)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await viewModel.load()
        }
    }
}

private extension ArtistListPage {
    enum Layout {
        static let minItemWidth: CGFloat = 176
        static let columnSpacing: CGFloat = 20
        static let rowSpacing: CGFloat = 20

        static let contentTopInset: CGFloat = 20
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    VStack {
        ArtistListPage()
    }
    .frame(minWidth: 1400, minHeight: 1000)
}

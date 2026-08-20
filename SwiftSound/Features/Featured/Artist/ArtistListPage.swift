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

            LazyVGrid(
                columns: [
                    GridItem(
                        .adaptive(minimum: Layout.minCardWidth),
                        spacing: Layout.rowSpacing,
                        alignment: .top
                    )
                ],
                alignment: .leading,
                spacing: Layout.columnSpacing
            ) {
                Section {
                    ForEach(viewModel.state.items) { artist in
                        ArtistCard(artist: artist)
                            .frame(maxWidth: .infinity)
                            .routeLink(to: .artist(id: artist.id))
                    }
                } footer: {
                    InfiniteScrollFooter(state: viewModel.state) {
                        await viewModel.loadMore()
                    }
                }
            }
            .padding(.top, Layout.contentTopInset)
            .loadingPlaceholder(viewModel.state.isInitialLoading)
        }
        .padding(.leading, Layout.leadingInset)
        .padding(.trailing, Layout.trailingInset)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await viewModel.load()
        }
    }
}

private extension ArtistListPage {
    enum Layout {
        static let minCardWidth: CGFloat = 176
        static let rowSpacing: CGFloat = 20
        static let columnSpacing: CGFloat = 20

        static let contentTopInset: CGFloat = 20
        static let leadingInset: CGFloat = 40
        static let trailingInset: CGFloat = 30
    }
}

#Preview {
    VStack {
        ArtistListPage()
    }
    .frame(minWidth: 1400, minHeight: 1000)
}

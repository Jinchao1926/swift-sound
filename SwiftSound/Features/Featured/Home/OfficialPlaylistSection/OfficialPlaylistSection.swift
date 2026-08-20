//
//  OfficialPlaylistSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct OfficialPlaylistSection: View {
    @StateObject private var viewModel = OfficialPlaylistSectionViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RouteTitleLink("官方歌单", route: FeaturedRoute.playlistDiscovery)
                .padding(.horizontal, Layout.titleHorizontalInset)

            Carousel(
                items: viewModel.state.items,
                configuration: CarouselConfiguration(
                    sizing: .adaptive(minimum: Layout.minCardWidth),
                    itemSpacing: Layout.cardSpacing,
                    showsPageIndicators: false,
                    pagingBehavior: .bounded,
                    autoPaging: .disabled
                )
            ) {
                PlaylistCover(playlist: $0)
            }
        }
        .padding(.leading, Layout.leadingInset)
        .padding(.bottom, Layout.bottomInset)
        .loadingPlaceholder(viewModel.state.isInitialLoading)
        .task {
            await viewModel.load()
        }
    }
}

private extension OfficialPlaylistSection {
    enum Layout {
        static let minCardWidth: CGFloat = 140
        static let cardSpacing: CGFloat = 15

        static let titleHorizontalInset: CGFloat = 30
        static let leadingInset: CGFloat = 10
        static let bottomInset: CGFloat = 16
    }
}

#Preview {
    OfficialPlaylistSection()
        .frame(minWidth: 600, minHeight: 300)
        .environmentObject(AppRouter())
}

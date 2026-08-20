//
//  NewMusicSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct NewMusicSection: View {
    @StateObject private var viewModel = NewMusicSectionViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RouteTitleLink("最新音乐", route: .newMusic())
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
                SongsGroupPage(songs: $0.songs)
            }
        }
        .padding(.bottom, Layout.bottomInset)
        .loadingPlaceholder(viewModel.state.isInitialLoading)
        .task {
            await viewModel.load()
        }
    }
}

private extension NewMusicSection {
    enum Layout {
        static let minCardWidth: CGFloat = 380
        static let cardSpacing: CGFloat = 15

        static let titleHorizontalInset: CGFloat = 40
        static let bottomInset: CGFloat = 16
    }
}

#Preview {
    NewMusicSection()
        .frame(minWidth: 600, minHeight: 300)
        .environmentObject(PlayerStore())
}

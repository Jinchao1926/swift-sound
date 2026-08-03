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
        FeaturedHomeSection(
            columnCandidates: [3, 2],
            minItemWidth: Layout.minCardWidth
        ) { columns in
            VStack(alignment: .leading, spacing: 0) {
                RouteTitleLink("最新音乐", route: AppRoute.newMusic())
                    .padding(.horizontal, 40)

                Carousel(
                    items: viewModel.state.items,
                    columns: columns,
                    showsDots: false,
                    isAutoScrollEnabled: false,
                    isInfiniteLoopEnabled: false,
                    isLastPageBackfillEnabled: true
                ) {
                    SongsGroupPage(songs: $0.songs)
                }
            }
            .padding(.trailing, 10)
            .task {
                await viewModel.load()
            }
        }
    }
}

private extension NewMusicSection {
    enum Layout {
        static let minCardWidth: CGFloat = 380
    }
}

#Preview {
    NewMusicSection()
        .frame(minWidth: 600, minHeight: 300)
}

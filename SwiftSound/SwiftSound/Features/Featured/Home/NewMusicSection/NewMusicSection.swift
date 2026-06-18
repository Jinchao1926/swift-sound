//
//  NewMusicSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct NewMusicSection: View {
    @StateObject private var viewModel = NewMusicSectionViewModel()
    @State private var availableWidth: CGFloat = 0

    var body: some View {
        FeaturedHomeSection(
            columnCandidates: [3, 2],
            minItemWidth: Layout.minCardWidth
        ) { columns in
            VStack(alignment: .leading, spacing: 0) {
                RouteTitleLink("最新音乐", route: AppRoute.newMusic())
                    .padding(.horizontal, 30)

                Carousel(
                    items: viewModel.state.songGroups,
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

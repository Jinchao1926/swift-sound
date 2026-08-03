//
//  OfficialPlaylistSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct OfficialPlaylistSection: View {
    @StateObject private var viewModel = OfficialPlaylistSectionViewModel()
    @State private var availableWidth: CGFloat = 0

    var body: some View {
        FeaturedHomeSection(
            columnCandidates: [6, 5, 4],
            minItemWidth: Layout.minCardWidth
        ) { columns in
            VStack(alignment: .leading, spacing: 0) {
                RouteTitleLink("官方歌单", route: FeaturedRoute.playlistSquare)
                    .padding(.horizontal, 30)

                Carousel(
                    items: viewModel.state.items,
                    columns: columns,
                    showsDots: false,
                    isAutoScrollEnabled: false,
                    isInfiniteLoopEnabled: false,
                    isLastPageBackfillEnabled: true
                ) {
                    PlaylistCover(playlist: $0)
                }
            }
            .padding(.horizontal, 10)
            .task {
                await viewModel.load()
            }
        }
    }
}

private extension OfficialPlaylistSection {
    enum Layout {
        static let minCardWidth: CGFloat = 180
    }
}

#Preview {
    OfficialPlaylistSection()
        .frame(minWidth: 600, minHeight: 300)
        .environmentObject(AppRouter())
}

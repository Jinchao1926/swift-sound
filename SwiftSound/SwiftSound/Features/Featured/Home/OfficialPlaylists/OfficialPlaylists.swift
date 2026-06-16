//
//  Playlists.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct OfficialPlaylists: View {
    @StateObject private var viewModel = OfficialPlaylistsViewModel()
    @State private var availableWidth: CGFloat = 0

    var body: some View {
        let columns = playlistColumns(for: availableWidth)

        VStack(alignment: .leading, spacing: 0) {
            RouteTitleLink("官方歌单", route: FeaturedRoute.playlistSquare)
                .padding(.horizontal, 30)

            Carousel(
                items: viewModel.state.playlists,
                columns: columns,
                spacing: Layout.cardSpacing,
                showsDots: false,
                isAutoScrollEnabled: false,
                isInfiniteLoopEnabled: false,
                isLastPageBackfillEnabled: true
            ) {
                PlaylistCover(playlist: $0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { newValue in
            availableWidth = newValue
        }
        .padding(.horizontal, 10)
        .padding(.top, 16)
        .task {
            await viewModel.load()
        }
    }
}

private extension OfficialPlaylists {
    enum Layout {
        static let cardSpacing: CGFloat = 20
        static let minCardWidth: CGFloat = 180
    }

    func playlistColumns(for width: CGFloat) -> Int {
        let sixColumnWidth = widthForColumns(6)
        let fiveColumnWidth = widthForColumns(5)

        if width >= sixColumnWidth {
            return 6
        }

        if width >= fiveColumnWidth {
            return 5
        }

        return 4
    }

    func widthForColumns(_ columns: Int) -> CGFloat {
        Layout.minCardWidth * CGFloat(columns) + Layout.cardSpacing * CGFloat(columns - 1)
    }
}

#Preview {
    OfficialPlaylists()
        .frame(minWidth: 600, minHeight: 300)
        .environmentObject(AppRouter())
}

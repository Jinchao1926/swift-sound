//
//  Playlists.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct OfficialPlaylists: View {
    @StateObject private var viewModel = OfficialPlaylistsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RouteTitleLink("官方歌单", route: FeaturedRoute.playlistSquare)
                .padding(.horizontal, 30)

            GeometryReader { proxy in
                let columns = playlistColumns(for: proxy.size.width)

                Carousel(
                    items: viewModel.state.playlists,
                    columns: columns,
                    spacing: Layout.cardSpacing,
                    showsDots: false,
                    isAutoScrollEnabled: false,
                    isInfiniteLoopEnabled: false
                ) {
                    PlaylistCover(playlist: $0)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.top, 20)
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
        .padding()
        .environmentObject(AppRouter())
}

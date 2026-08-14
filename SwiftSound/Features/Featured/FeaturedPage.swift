//
//  FeaturedPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct FeaturedPage: View {
    let route: FeaturedRoute

    var body: some View {
        VStack(spacing: 10) {
            RouteTabView(selectedRoute: route)
                .padding(.horizontal, Layout.horizontalPadding)

            ScrollView(.vertical, showsIndicators: false) {
                content
                    .padding(.bottom, Layout.bottomPadding)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .featured:
            FeaturedHomePage()
        case .playlistSquare:
            PlaylistSquarePage()
        case .ranking:
            RankingListPage()
        case .artist:
            ArtistListPage()
        case .vip:
            VIPPage()
        }
    }
}

private extension FeaturedPage {
    enum Layout {
        static let bottomPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 40
    }
}

#Preview {
    FeaturedPage(route: .featured)
        .frame(minWidth: 800, minHeight: 800)
}

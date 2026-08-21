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
                .padding(.horizontal, Layout.horizontalInset)

            ScrollView {
                content
                    .padding(.bottom, Layout.bottomInset)
            }
            .scrollIndicatorOverlay()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .featured:
            FeaturedHomePage()
        case .playlistDiscovery:
            PlaylistDiscoveryPage()
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
        static let bottomInset: CGFloat = 20
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    FeaturedPage(route: .featured)
        .frame(minWidth: 800, minHeight: 800)
}

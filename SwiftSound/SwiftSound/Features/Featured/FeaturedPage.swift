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
            ScrollView(.vertical, showsIndicators: false) {
                content
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom, 35)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            RankingPage()
        case .artist:
            ArtistPage()
        case .vip:
            VIPPage()
        }
    }
}

#Preview {
    FeaturedPage(route: .featured)
        .frame(minWidth: 800, minHeight: 800)
}

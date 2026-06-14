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
            FeaturedTab(selectedRoute: route)
            content
            Spacer(minLength: 0)
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
}

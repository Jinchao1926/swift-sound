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
        }
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .featured:
            PlaceholderPage(title: "精选")
        case .playlistSquare:
            PlaceholderPage(title: "歌单广场")
        case .ranking:
            PlaceholderPage(title: "排行榜")
        case .artist:
            PlaceholderPage(title: "歌手")
        case .vip:
            PlaceholderPage(title: "VIP")
        }
    }
}

#Preview {
    FeaturedPage(route: .featured)
}

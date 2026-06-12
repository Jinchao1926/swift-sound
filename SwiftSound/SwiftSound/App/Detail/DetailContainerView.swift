//
//  DetailContainerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct DetailContainerView: View {
    let route: HomeRoute
    let canGoBack: Bool
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            TopToolbarView(canGoBack: canGoBack, onBack: onBack)

            content
        }
        .background(Color.surfacePrimary)
        .ignoresSafeArea(edges: .top)   // important
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .featured:
            FeaturedPage()
        case .podcast:
            PodcastPage()
        case .follow:
            FollowPage()
        case .favorite:
            FavoritePage()
        case .played:
            PlayedPage()
        case .download:
            DownloadPage()
        }
    }
}

#Preview {
    DetailContainerView(route: .featured, canGoBack: true, onBack: {})
}

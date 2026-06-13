//
//  DetailContainerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct DetailContainerView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        VStack(spacing: 0) {
            TopToolbarView()

            content
        }
        .background(Color.surfacePrimary)
        .ignoresSafeArea(edges: .top)   // important
    }

    @ViewBuilder
    private var content: some View {
        switch router.currentRoute {
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
    DetailContainerView()
        .environmentObject(AppRouter())
}

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

            NavigationStack(path: $router.path) {
                routeView(router.rootRoute)
                    .navigationDestination(for: AppRoute.self) { route in
                        routeView(route)
                            .navigationBarBackButtonHidden(true)    // hide system navigation back button
                    }
            }
        }
        .background(Color.surfacePrimary)
        .ignoresSafeArea(edges: .top)   // important
    }

    @ViewBuilder
    private func routeView(_ route: AppRoute) -> some View {
        switch route {
        case .featured(let tab):
            FeaturedPage(route: tab)
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

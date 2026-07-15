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
                routeView(router.rootRoute) // 根页面（栈底）
                    .navigationDestination(for: AppRoute.self) { route in
                        routeView(route)    // 捕获 path 路由生成子页面
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
        case .featured(let secondary):
            FeaturedPage(route: secondary)
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
        case .newMusic(let secondary):
            NewMusicPage(route: secondary)
        }
    }
}

#Preview {
    DetailContainerView()
        .frame(minWidth: 800, minHeight: 800)
        .environmentObject(AppRouter())
}

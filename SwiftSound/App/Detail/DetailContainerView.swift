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
                routedPage(router.rootRoute) // 根页面（栈底）
                    .navigationDestination(for: AppRoute.self) { route in
                        routedPage(route)    // 捕获 path 路由生成子页面
                            .navigationBarBackButtonHidden(true)    // hide system navigation back button
                    }
            }
        }
        .background(Color.surfacePrimary)
        .ignoresSafeArea(edges: .top)   // important
    }

    private func routedPage(_ route: AppRoute) -> some View {
        VStack(spacing: 0) {
            routeView(route)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        case .artist(let id, let secondary):
            ArtistDetailPage(id: id, route: secondary)
        case .user(let id, let secondary):
            UserDetailPage(id: id, route: secondary)
        }
    }
}

#Preview {
    DetailContainerView()
        .frame(minWidth: 800, minHeight: 800)
        .environmentObject(AppRouter())
}

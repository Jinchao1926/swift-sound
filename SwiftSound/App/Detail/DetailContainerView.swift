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

            routedPage(router.currentRoute)
        }
        .background(Color.surfacePrimary)
        .ignoresSafeArea(edges: .top)   // important
    }

    private func routedPage(_ route: AppRoute) -> some View {
        VStack(spacing: 0) {
            routeView(route)
            Spacer(minLength: 0)
        }
        // 完整 route 负责历史记录，pageKey 负责页面 shell 复用。
        // 例如 NewMusic/Artist/User 的二级 tab 变化时，只更新内容，不重建外层页面状态。
        .id(route.pageRoute)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    // swiftlint:disable cyclomatic_complexity
    @ViewBuilder
    private func routeView(_ route: AppRoute) -> some View {
        switch route {
        // Sidebar routes
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
        // Others
        case .newMusic(let secondary):
            NewMusicPage(route: secondary)
        case .featuredPlaylist(let category):
            FeaturedPlaylistPage(initialCategory: category)
        // Details
        case .artistSongs(let id):
            ArtistSongsPage(id: id)
        case .artist(let id, let secondary):
            ArtistDetailPage(id: id, route: secondary)
        case .album(let id, let secondary):
            AlbumDetailPage(id: id, route: secondary)
        case .playlist(let id, let secondary):
            PlaylistDetailPage(id: id, route: secondary)
        case .user(let id, let secondary):
            UserDetailPage(id: id, route: secondary)
        case .mv(let id):
            MVDetailPage(id: id)
        // Settings
        case .setting:
            SettingPage()
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

#Preview {
    DetailContainerView()
        .frame(minWidth: 800, minHeight: 800)
        .environmentObject(AppRouter())
}

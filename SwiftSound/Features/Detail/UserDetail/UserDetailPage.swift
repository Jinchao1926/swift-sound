//
//  UserDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import SwiftUI

struct UserDetailPage: View {
    let id: Int
    let route: UserRoute

    @StateObject private var viewModel: UserDetailViewModel

    init(id: Int, route: UserRoute) {
        self.id = id
        self.route = route
        self._viewModel = StateObject(wrappedValue: UserDetailViewModel(id: id))
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: Layout.spacing) {
                    if let detail = viewModel.state.value {
                        UserDetailHeader(detail: detail)
                    }

                    RouteTabView(
                        selectedRoute: route,
                        destinationRoute: { .user(id: id, secondary: $0) },
                        badgeText: tabBadgeText
                    )

                    content(for: route) {
                        withAnimation {
                            proxy.scrollTo(ScrollTarget.top, anchor: .top)
                        }
                    }
                }
                .id(ScrollTarget.top)
                .padding(.horizontal, Layout.horizontalInset)
            }
            .scrollIndicatorOverlay()
            .task {
                await viewModel.load()
            }
        }
    }

    @ViewBuilder
    private func content(
        for route: UserRoute,
        onScrollToTop: @escaping () -> Void
    ) -> some View {
        switch route {
        case .playlists:
            UserPlaylistsPage(
                viewModel: viewModel,
                onScrollToTop: onScrollToTop
            )
        case .notes:
            UserNotesPage()
        case .podcasts:
            UserPodcastsPage()
        }
    }

    private func tabBadgeText(for route: UserRoute) -> String? {
        switch route {
        case .notes:
            return viewModel.state.value?.profile.eventCount?.formatted()
        default:
            return nil
        }
    }
}

private extension UserDetailPage {
    enum ScrollTarget: Hashable {
        case top
    }

    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    ScrollView {
        UserDetailPage(id: 1, route: .playlists)
    }
    .frame(width: 800, height: 600)
}

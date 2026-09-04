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
                    UserDetailHeader(detail: viewModel.state.value)

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
            .task {
                await viewModel.loadRadios()
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
        case .radios:
            UserRadiosPage(viewModel: viewModel)
        }
    }

    private func tabBadgeText(for route: UserRoute) -> String? {
        switch route {
        case .notes:
            return viewModel.state.value?.profile.eventCount?.formatted()
        case .radios:
            return viewModel.radioCount?.formatted()
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

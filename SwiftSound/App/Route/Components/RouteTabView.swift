//
//  RouteTabView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

// MARK: - RouteTabView
struct RouteTabView<Route, Trailing>: View where Route: RouteTabProtocol, Trailing: View {
    let selectedRoute: Route
    private let destinationRoute: (Route) -> AppRoute
    private let badgeText: (Route) -> String?
    private let trailingSlot: () -> Trailing

    @EnvironmentObject private var router: AppRouter

    init(
        selectedRoute: Route,
        destinationRoute: @escaping (Route) -> AppRoute,
        badgeText: @escaping (Route) -> String? = { _ in nil },
        @ViewBuilder trailingSlot: @escaping () -> Trailing
    ) {
        self.selectedRoute = selectedRoute
        self.destinationRoute = destinationRoute
        self.badgeText = badgeText
        self.trailingSlot = trailingSlot
    }

    var body: some View {
        HStack(spacing: 0) {
            SelectableTabView(
                items: Array(Route.allCases),
                selectedID: selectedRoute.id,
                title: \.title,
                badgeText: badgeText,
                onSelected: { route in
                    router.navigate(to: destinationRoute(route))
                }
            )
            Spacer()
            trailingSlot()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }
}

extension RouteTabView where Trailing == EmptyView {
    init(
        selectedRoute: Route,
        destinationRoute: @escaping (Route) -> AppRoute,
        badgeText: @escaping (Route) -> String? = { _ in nil }
    ) {
        self.init(
            selectedRoute: selectedRoute,
            destinationRoute: destinationRoute,
            badgeText: badgeText,
            trailingSlot: { EmptyView() }
        )
    }
}

extension RouteTabView where Route: SecondaryRouteProtocol, Trailing == EmptyView {
    init(selectedRoute: Route) {
        self.init(
            selectedRoute: selectedRoute,
            destinationRoute: { $0.destinationRoute }
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(alignment: .leading, spacing: 18) {
        RouteTabView(selectedRoute: FeaturedRoute.featured)

        Divider()

        RouteTabView(
            selectedRoute: ArtistRoute.songs,
            destinationRoute: { .artist(id: Artist.preview.id, secondary: $0) }
        )

        Divider()

        RouteTabView(
            selectedRoute: AlbumRoute.songs,
            destinationRoute: { .album(id: Album.preview.id, secondary: $0) },
            badgeText: {
                switch $0 {
                case .songs:
                    return "100"
                case .comments:
                    return "639"
                case .profile:
                    return nil
                }
            },
            trailingSlot: {
                HStack(spacing: 5) {
                    Image(systemName: "magnifyingglass")
                    Text("搜索")
                }
                .font(.font13)
                .foregroundStyle(Color.textSecondary.opacity(0.72))
            }
        )
    }
    .padding()
    .environmentObject(AppRouter())
}

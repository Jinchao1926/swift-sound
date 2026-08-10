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
        HStack(spacing: 24) {
            ForEach(Array(Route.allCases)) {
                RouteTabItem(
                    route: $0,
                    badgeText: badgeText($0),
                    isSelected: $0 == selectedRoute,
                    destinationRoute: destinationRoute
                )
            }
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

// MARK: - RouteTabItem
private struct RouteTabItem<Route: RouteTabProtocol>: View {
    let route: Route
    let badgeText: String?
    let isSelected: Bool
    let destinationRoute: (Route) -> AppRoute

    @EnvironmentObject private var router: AppRouter

    init(
        route: Route,
        badgeText: String? = nil,
        isSelected: Bool,
        destinationRoute: @escaping (Route) -> AppRoute
    ) {
        self.route = route
        self.badgeText = badgeText
        self.isSelected = isSelected
        self.destinationRoute = destinationRoute
    }

    var body: some View {
        Button {
            router.navigate(to: destinationRoute(route))
        } label: {
            VStack(spacing: 3) {
                HStack(alignment: .top, spacing: 2) {
                    Text(route.title)
                        .font(.font16.weight(.medium))
                        .foregroundStyle(isSelected ? Color.textPrimary : Color.textSecondary)

                    if let badgeText, !badgeText.isEmpty {
                        Text(badgeText)
                            .font(.font11.weight(.semibold))
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                Capsule(style: .continuous)
                    .fill(isSelected ? Color.accentPrimary : Color.clear)
                    .frame(width: 18, height: 3)
            }
            .frame(height: 30)
            .contentShape(Rectangle())
            .pointerStyle(.link)
        }
        .buttonStyle(.plain)
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
                    return "2"
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

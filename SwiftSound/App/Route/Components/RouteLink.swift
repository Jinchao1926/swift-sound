//
//  RouteLink.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/24.
//

import SwiftUI

struct RouteLink<Label: View>: View {
    @EnvironmentObject private var router: AppRouter

    private let label: () -> Label
    private let navigate: (AppRouter) -> Void

    // MARK: - LifeCycle
    init(
        navigate: @escaping (AppRouter) -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self.navigate = navigate
    }

    init(route: AppRoute, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.navigate = { $0.navigate(to: route) }
    }

    init<Route: SecondaryRouteProtocol>(
        route: Route,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self.navigate = { $0.navigate(to: route) }
    }

    // MARK: - UI
    var body: some View {
        Button {
            navigate(router)
        } label: {
            label()
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }
}

private struct RouteLinkModifier: ViewModifier {
    @EnvironmentObject private var router: AppRouter

    private let navigate: (AppRouter) -> Void

    init(navigate: @escaping (AppRouter) -> Void) {
        self.navigate = navigate
    }

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                navigate(router)
            }
            .pointerStyle(.link)
            .accessibilityAddTraits(.isLink)
            .accessibilityAction {
                navigate(router)
            }
    }
}

extension View {
    func routeLink(navigate: @escaping (AppRouter) -> Void) -> some View {
        modifier(RouteLinkModifier(navigate: navigate))
    }

    func routeLink(to route: AppRoute) -> some View {
        routeLink {
            $0.navigate(to: route)
        }
    }

    func routeLink<Route: SecondaryRouteProtocol>(to route: Route) -> some View {
        routeLink {
            $0.navigate(to: route)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        RouteLink(route: FeaturedRoute.playlistSquare) {
            HStack(spacing: 4) {
                Text("歌单广场")
                    .font(.font16.weight(.medium))

                Image(systemName: "chevron.right")
                    .font(.font14)
            }
            .foregroundStyle(Color.textPrimary)
            .frame(height: 40)
            .padding(.horizontal, 16)
        }

        Text("Modifier route link")
            .font(.font14)
            .foregroundStyle(Color.textSecondary)
            .padding(12)
            .routeLink(to: FeaturedRoute.playlistSquare)
    }
    .padding()
    .environmentObject(AppRouter())
}

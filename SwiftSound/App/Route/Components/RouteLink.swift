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
    private let isEnabled: Bool

    // MARK: - LifeCycle
    init(
        navigate: @escaping (AppRouter) -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self.navigate = navigate
        self.isEnabled = true
    }

    init(route: AppRoute, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.navigate = { $0.navigate(to: route) }
        self.isEnabled = route.isValid
    }

    init<Route: SecondaryRouteProtocol>(
        route: Route,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self.navigate = { $0.navigate(to: route) }
        self.isEnabled = route.destinationRoute.isValid
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
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.5)
        .pointerStyle(isEnabled ? .link : .default)
    }
}

private struct RouteLinkModifier: ViewModifier {
    @EnvironmentObject private var router: AppRouter

    private let navigate: (AppRouter) -> Void
    private let isEnabled: Bool

    init(navigate: @escaping (AppRouter) -> Void, isEnabled: Bool = true) {
        self.navigate = navigate
        self.isEnabled = isEnabled
    }

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                navigate(router)
            }
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.5)
            .pointerStyle(isEnabled ? .link : .default)
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
        modifier(RouteLinkModifier(
            navigate: { $0.navigate(to: route) },
            isEnabled: route.isValid
        ))
    }

    func routeLink<Route: SecondaryRouteProtocol>(to route: Route) -> some View {
        modifier(RouteLinkModifier(
            navigate: { $0.navigate(to: route) },
            isEnabled: route.destinationRoute.isValid
        ))
    }
}

#Preview {
    VStack(spacing: 12) {
        RouteLink(route: FeaturedRoute.playlistDiscovery) {
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
            .routeLink(to: FeaturedRoute.playlistDiscovery)
    }
    .padding()
    .environmentObject(AppRouter())
}

//
//  RouteTabView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct RouteTabView<Route>: View where Route: SecondaryRouteProtocol {
    let selectedRoute: Route

    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            ForEach(Array(Route.allCases)) {
                RouteTabItem(route: $0, isSelected: $0 == selectedRoute)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 40)
        .padding(.top, 10)
    }
}

private struct RouteTabItem<Route: SecondaryRouteProtocol>: View {
    let route: Route
    let isSelected: Bool

    @EnvironmentObject private var router: AppRouter

    var body: some View {
        Button {
            router.navigate(to: route)
        } label: {
            VStack(spacing: 3) {
                Text(route.title)
                    .font(.font16.weight(.medium))
                    .foregroundStyle(isSelected ? Color.textPrimary : Color.textSecondary)

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

#Preview {
    VStack {
        RouteTabView(selectedRoute: FeaturedRoute.featured)
            .environmentObject(AppRouter())

        Divider()

        RouteTabView(selectedRoute: LatestMusicRoute.newTrack)
            .environmentObject(AppRouter())
    }
    .padding()
}

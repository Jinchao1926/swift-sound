//
//  RouteTitleLink.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct RouteTitleLink: View {
    private let title: String
    private let navigate: (AppRouter) -> Void

    // MARK: - LifeCycle
    init(_ title: String, route: AppRoute) {
        self.title = title
        self.navigate = { $0.navigate(to: route) }
    }

    init<Route: SecondaryRouteProtocol>(_ title: String, route: Route) {
        self.title = title
        self.navigate = { $0.navigate(to: route) }
    }

    // MARK: - UI
    var body: some View {
        RouteLink(navigate: navigate) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.font16.weight(.medium))

                Image(systemName: "chevron.right")
                    .font(.font14)
            }
            .foregroundStyle(Color.textPrimary)
            .contentShape(Rectangle())
            .frame(height: 40)
        }
    }
}

#Preview {
    RouteTitleLink("官方歌单", route: FeaturedRoute.playlistSquare)
        .padding()
        .environmentObject(AppRouter())
}

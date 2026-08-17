//
//  RouteTitleLink.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct RouteTitleLink: View {
    enum Variant {
        case large
        case medium
    }

    private let title: String
    private let navigate: (AppRouter) -> Void
    private let variant: Variant

    // MARK: - LifeCycle
    init(_ title: String, route: AppRoute, variant: Variant = .medium) {
        self.title = title
        self.navigate = { $0.navigate(to: route) }
        self.variant = variant
    }

    init<Route: SecondaryRouteProtocol>(
        _ title: String,
        route: Route,
        variant: Variant = .medium
    ) {
        self.title = title
        self.navigate = { $0.navigate(to: route) }
        self.variant = variant
    }

    // MARK: - UI
    var body: some View {
        RouteLink(navigate: navigate) {
            HStack(spacing: 4) {
                Text(title)
                    .font(titleFont)

                Image(systemName: "chevron.right")
                    .font(chevornFont)
            }
            .foregroundStyle(Color.textPrimary)
            .contentShape(Rectangle())
            .frame(height: 40)
        }
    }

    private var titleFont: Font {
        switch variant {
        case .large:
            .font18.weight(.semibold)
        case .medium:
            .font16.weight(.medium)
        }
    }

    private var chevornFont: Font {
        switch variant {
        case .large:
            .font16
        case .medium:
            .font14
        }
    }
}

#Preview {
    RouteTitleLink("官方歌单", route: FeaturedRoute.playlistDiscovery)
        .padding()
        .environmentObject(AppRouter())
}

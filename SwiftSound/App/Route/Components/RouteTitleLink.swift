//
//  RouteTitleLink.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct RouteTitleLink: View {
    @EnvironmentObject private var router: AppRouter

    private let title: String
    private let navigate: (AppRouter) -> Void

    // MARK: - LifeCycle
    init(_ title: String, route: AppRoute) {
        self.title = title
        self.navigate = {
            $0.navigate(to: route)
        }
    }

    init(_ title: String, route: FeaturedRoute) {
        self.title = title
        self.navigate = {
            $0.navigate(to: route)
        }
    }

    // MARK: - UI
    var body: some View {
        Button {
            navigate(router)
        } label: {
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
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }
}

#Preview {
    RouteTitleLink("官方歌单", route: FeaturedRoute.playlistSquare)
        .padding()
        .environmentObject(AppRouter())
}

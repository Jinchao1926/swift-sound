//
//  FeaturedTab.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct FeaturedTab: View {
    let selectedRoute: FeaturedRoute

    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            ForEach(FeaturedRoute.allCases) { tab in
                FeaturedTabItem(route: tab, isSelected: tab == selectedRoute)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 40)
        .padding(.top, 10)
    }
}

struct FeaturedTabItem: View {
    let route: FeaturedRoute
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
    FeaturedTab(selectedRoute: .featured)
        .environmentObject(AppRouter())
}

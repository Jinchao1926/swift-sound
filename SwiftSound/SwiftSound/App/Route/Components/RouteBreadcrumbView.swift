//
//  RouteBreadcrumbView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import SwiftUI

struct RouteBreadcrumbView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Array(router.routeStack.enumerated()), id: \.offset) { index, route in
                if index > 0 {
                    Image(systemName: "chevron.right")
                        .font(.font9.weight(.semibold))
                        .foregroundStyle(Color.textSecondary.opacity(0.38))
                }

                Button {
                    router.navigateBack(to: route)
                } label: {
                    Text(route.title)
                        .font(.font14)
                        .foregroundStyle(
                            index == router.routeStack.count - 1
                                ? Color.textPrimary
                                : Color.textSecondary
                        )
                        .lineLimit(1)
                }
                .buttonStyle(.plain)
                .disabled(index == router.routeStack.count - 1)
                .pointerStyle(.link)
            }
        }
        .lineLimit(1)
    }
}

#Preview {
    RouteBreadcrumbView()
        .environmentObject(AppRouter())
}

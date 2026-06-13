//
//  BreadcrumbButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import SwiftUI

struct BreadcrumbButton: View {
    @EnvironmentObject private var router: AppRouter

    @State private var isBackButtonHovering: Bool = false

    var body: some View {
        Button(action: router.goBack) {
            Image(systemName: "chevron.left")
                .font(.label)
                .foregroundStyle(router.canGoBack ? Color.textSecondary : Color.textSecondary.opacity(0.35))
                .frame(width: 26, height: 35)
                .roundedBackground(fill: backButtonBackground)
        }
        .buttonStyle(.plain)
        .disabled(!router.canGoBack)
        .onHover { isBackButtonHovering = router.canGoBack && $0 }
        .pointerStyle(router.canGoBack ? .link : .default)
        .help("后退")
    }

    private var backButtonBackground: Color {
        router.canGoBack && isBackButtonHovering ? Color(hex: 0xE1E5E9) : Color.white.opacity(0.76)
    }
}

#Preview {
    BreadcrumbButton()
        .environmentObject(AppRouter())
}

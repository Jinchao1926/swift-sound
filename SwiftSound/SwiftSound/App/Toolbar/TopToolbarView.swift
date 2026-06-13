//
//  TopToolbarView.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/12.
//

import SwiftUI

struct TopToolbarView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var searchText = ""
    @State private var isBackButtonHovering = false
    @State private var isMicrophoneButtonHovering = false

    var body: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            BreadcrumbButton()
            searchField
            microphoneButton
            Spacer(minLength: Layout.controlSpacing)
            trailingActions
        }
        .frame(maxWidth: .infinity, minHeight: Layout.height, maxHeight: Layout.height, alignment: .center)
        .padding(.horizontal, Layout.horizontalInset)
        .background(Color.surfacePrimary)
    }

    private var searchField: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            Image(systemName: "magnifyingglass")
                .font(.label)
                .foregroundStyle(Color.textSecondary.opacity(0.72))

            TextField(
                "",
                text: $searchText,
                prompt: Text("陈奕迅")
                    .foregroundStyle(Color.textSecondary.opacity(0.55))
            )
            .textFieldStyle(.plain)
            .font(.label)
            .foregroundStyle(Color.textPrimary)
            .lineLimit(1)
        }
        .padding(.horizontal, Layout.searchHorizontalInset)
        .frame(width: Layout.searchWidth, height: Layout.controlHeight)
        .roundedBackground(fill: Style.searchBackground)
    }

    private var microphoneButton: some View {
        Button(action: {}) {
            Image(systemName: "mic")
                .font(.head6)
                .foregroundStyle(Color.textSecondary)
                .frame(width: Layout.controlHeight, height: Layout.controlHeight)
                .roundedBackground(fill: isMicrophoneButtonHovering ? Style.controlHoverBackground : Style.microphoneBackground)
        }
        .buttonStyle(.plain)
        .onHover { isMicrophoneButtonHovering = $0 }
        .pointerStyle(.link)
    }

    private var trailingActions: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            loginStatus

            ToolbarIconButton(systemName: "envelope")
            ToolbarIconButton(systemName: "hexagon")
            ToolbarIconButton(systemName: "tshirt")
            ToolbarIconButton(systemName: "rectangle.on.rectangle")
        }
    }

    private var loginStatus: some View {
        HStack(alignment: .center, spacing: Layout.loginStatusSpacing) {
            ZStack {
                Circle()
                    .fill(Color.surfaceSecondary)
                    .frame(width: Layout.avatarSize, height: Layout.avatarSize)

                Image(systemName: "person")
                    .font(.label)
                    .foregroundStyle(Color.textSecondary)
            }
            .pointerStyle(.link)

            Text("未登录")
                .font(.label)
                .foregroundStyle(Color.textPrimary)
                .pointerStyle(.link)

            Text("VIP开通")
                .font(.system(size: 9))
                .foregroundStyle(.white)
                .padding(.horizontal, Layout.vipBadgeHorizontalInset)
                .frame(height: Layout.vipBadgeHeight)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.textSecondary.opacity(0.28))
                )
                .pointerStyle(.link)
            
            ToolbarIconButton(systemName: "chevron.down")
        }
        .frame(height: Layout.controlHeight)
    }

    private enum Layout {
        static let height: CGFloat = 90
        static let horizontalInset: CGFloat = 40

        static let controlSpacing: CGFloat = 10
        static let loginStatusSpacing: CGFloat = 4

        static let controlHeight: CGFloat = 35
        static let searchWidth: CGFloat = 258
        static let searchHorizontalInset: CGFloat = 12
        
        static let trailingIconSize: CGFloat = 20
        static let avatarSize: CGFloat = 28
        static let vipBadgeHeight: CGFloat = 16
        static let vipBadgeHorizontalInset: CGFloat = 5

        static let cornerRadius: CGFloat = 6
    }

    private enum Style {
        static let searchBackground = LinearGradient(
            colors: [Color(hex: 0xEAF1FC), Color(hex: 0xF8EFF8)],
            startPoint: .leading,
            endPoint: .trailing
        )
        static let searchBorder = Color(hex: 0xF9E3E5)
        static let microphoneBackground = Color(hex: 0xF6F0F9)
        static let controlHoverBackground = Color(hex: 0xF7E6F4)
    }
}

#Preview {
    TopToolbarView()
        .frame(width: 1180)
        .environmentObject(AppRouter())
}

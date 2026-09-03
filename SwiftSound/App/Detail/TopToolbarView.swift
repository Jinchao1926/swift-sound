//
//  TopToolbarView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import SwiftUI

struct TopToolbarView: View {
    @State private var searchText = ""
    @State private var isMicroButtonHovering = false

    var body: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            RouteBackButton()
            searchField
            microphoneButton
            Spacer(minLength: Layout.controlSpacing)
            trailingActions
        }
        .padding(.top, Layout.topInset)
        .padding(.horizontal, Layout.horizontalInset)
        .frame(maxWidth: .infinity, minHeight: Layout.height, maxHeight: Layout.height, alignment: .center)
        .background(Color.surfacePrimary)
    }

    private var searchField: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            Image(systemName: "magnifyingglass")
                .font(.font14)
                .foregroundStyle(Color.textSecondary.opacity(0.72))

            TextField(
                "",
                text: $searchText,
                prompt: Text("陈奕迅")
                    .foregroundStyle(Color.textSecondary.opacity(0.55))
            )
            .textFieldStyle(.plain)
            .font(.font14)
            .foregroundStyle(Color.textPrimary)
            .lineLimit(1)
        }
        .padding(.horizontal, Layout.searchHorizontalInset)
        .frame(width: Layout.searchWidth, height: Layout.controlHeight)
        .roundedBackground(fill: Style.searchBackground)
    }

    private var microphoneButton: some View {
        Button {} label: {
            Image(systemName: "mic")
                .font(.font16)
                .foregroundStyle(Color.textSecondary)
                .frame(width: Layout.controlHeight, height: Layout.controlHeight)
                .roundedBackground(
                    fill: isMicroButtonHovering ? Style.controlHoverBackground : Style.microphoneBackground
                )
        }
        .buttonStyle(.plain)
        .onHover { isMicroButtonHovering = $0 }
        .pointerStyle(.link)
        .help("听歌识曲")
    }

    private var trailingActions: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            loginStatus

            IconButton(systemName: "envelope").help("消息中心")
            IconButton(systemName: "hexagon")
                .routeLink(to: .setting)
                .help("设置")
            IconButton(systemName: "tshirt").help("换肤")
            IconButton(systemName: "rectangle.on.rectangle").help("mini")
        }
    }

    private var loginStatus: some View {
        HStack(alignment: .center, spacing: Layout.loginStatusSpacing) {
            ZStack {
                Circle()
                    .fill(Color.surfaceSecondary)
                    .frame(width: Layout.avatarSize, height: Layout.avatarSize)

                Image(systemName: "person")
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
            }
            .pointerStyle(.link)

            Text("未登录")
                .font(.font14)
                .foregroundStyle(Color.textPrimary)
                .pointerStyle(.link)

            Text("VIP开通")
                .font(.font9)
                .foregroundStyle(.white)
                .padding(.horizontal, Layout.vipBadgeHorizontalInset)
                .frame(height: Layout.vipBadgeHeight)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.textSecondary.opacity(0.28))
                )
                .pointerStyle(.link)

            IconButton(systemName: "chevron.down")
        }
        .frame(height: Layout.controlHeight)
    }

    private enum Layout {
        static let height: CGFloat = 90
        static let horizontalInset: CGFloat = 40
        static let topInset: CGFloat = 10

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

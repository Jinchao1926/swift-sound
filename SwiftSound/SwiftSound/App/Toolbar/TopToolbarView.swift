//
//  TopToolbarView.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/12.
//

import SwiftUI

struct TopToolbarView: View {
    let canGoBack: Bool
    let onBack: () -> Void

    @State private var searchText = ""

    var body: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            backButton
            searchField
            microphoneButton
            Spacer(minLength: Layout.controlSpacing)
            trailingActions
        }
        .frame(maxWidth: .infinity, minHeight: Layout.height, maxHeight: Layout.height, alignment: .center)
        .padding(.horizontal, Layout.horizontalInset)
        .background(Color.surfacePrimary)
    }

    private var backButton: some View {
        Button(action: onBack) {
            Image(systemName: "chevron.left")
                .font(.label)
                .foregroundStyle(canGoBack ? Color.textSecondary : Color.textSecondary.opacity(0.35))
                .frame(width: Layout.backButtonWidth, height: Layout.controlHeight)
                .background(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.76))
                        .stroke(Color.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(!canGoBack)
        .pointerStyle(.link)
    }

    private var searchField: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            Image(systemName: "magnifyingglass")
                .font(.label)
                .foregroundStyle(Color.textSecondary.opacity(0.72))

            TextField("", text: $searchText, prompt: Text("🔥大家都在搜 NIGHT DANCER")
                .foregroundStyle(Color.textSecondary.opacity(0.55)))
                .textFieldStyle(.plain)
                .font(.label)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
        }
        .padding(.horizontal, Layout.searchHorizontalInset)
        .frame(width: Layout.searchWidth, height: Layout.controlHeight)
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(Style.searchBackground)
                .stroke(Style.searchBorder, lineWidth: 1)
        )
    }

    private var microphoneButton: some View {
        Button(action: {}) {
            Image(systemName: "mic")
                .font(.head6)
                .foregroundStyle(Color.textSecondary)
                .frame(width: Layout.controlHeight, height: Layout.controlHeight)
                .background(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                        .fill(Style.searchBackground)
                        .stroke(Style.searchBorder, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }

    private var trailingActions: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            loginStatus

            toolbarIcon("envelope")
            toolbarIcon("hexagon")
            toolbarIcon("tshirt")
            toolbarIcon("rectangle.on.rectangle")
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
            
            toolbarIcon("chevron.down")
        }
        .frame(height: Layout.controlHeight)
    }

    private func toolbarIcon(_ systemName: String) -> some View {
        Button(action: {}) {
            Image(systemName: systemName)
                .font(.label)
                .foregroundStyle(Color.textSecondary)
                .frame(width: Layout.trailingIconSize, height: Layout.trailingIconSize)
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }

    private enum Layout {
        static let height: CGFloat = 90
        static let horizontalInset: CGFloat = 40

        static let controlSpacing: CGFloat = 10
        static let loginStatusSpacing: CGFloat = 4

        static let controlHeight: CGFloat = 35
        static let backButtonWidth: CGFloat = 26
        static let searchWidth: CGFloat = 258
        static let searchHorizontalInset: CGFloat = 12
        
        static let trailingIconSize: CGFloat = 20
        static let avatarSize: CGFloat = 28
        static let vipBadgeHeight: CGFloat = 16
        static let vipBadgeHorizontalInset: CGFloat = 5

        static let cornerRadius: CGFloat = 5
    }

    private enum Style {
        static let searchBackground = Color(hex: 0xFFF6FB)
        static let searchBorder = Color(hex: 0xF3E3EE)
    }
}

#Preview {
    TopToolbarView(canGoBack: true, onBack: {})
        .frame(width: 1180)
}

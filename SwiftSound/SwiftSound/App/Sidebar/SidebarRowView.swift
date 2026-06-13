//
//  SidebarRowView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct SidebarRowView: View {
    let route: AppRoute

    // MARK: - Private
    @EnvironmentObject private var router: AppRouter
    @State private var isHovering = false

    private var isSelected: Bool { route == router.currentRoute }

    // MARK: - UI
    var body: some View {
        Button {
            router.navigate(to: route)
        } label: {
            HStack(spacing: Layout.contentSpacing) {
                Image(systemName: route.systemImage)
                    .font(.system(size: Layout.iconSize))
                    .foregroundStyle(isSelected ? Color.white : Color.textSecondary)
                    .frame(width: Layout.iconSize)

                Text(route.title)
                    .font(.label)
                    .foregroundStyle(isSelected ? Color.white : Color.textPrimary)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, Layout.highlightHorizontalInset)
            .frame(maxWidth: .infinity, minHeight: Layout.highlightHeight, maxHeight: Layout.highlightHeight)
            .background(background)
            .contentShape(Rectangle())
            .pointerStyle(.link)
            .padding(.vertical, Layout.rowVerticalInset)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
    }

    @ViewBuilder
    private var background: some View {
        if isSelected || isHovering {
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(isSelected ? Color.accentPrimary : Color.surfaceHover)
        }
    }

    private enum Layout {
        static let cornerRadius: CGFloat = 6
        static let rowVerticalInset: CGFloat = 2
        static let highlightHeight: CGFloat = 38
        static let highlightHorizontalInset: CGFloat = 14

        static let contentSpacing: CGFloat = 12
        static let iconSize: CGFloat = 16
    }
}

#Preview {
    SidebarRowView(route: .featured)
        .frame(minWidth: 203, maxWidth: 203)
        .padding()
        .environmentObject(AppRouter())
}

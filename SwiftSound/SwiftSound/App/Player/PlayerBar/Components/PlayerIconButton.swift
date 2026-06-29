//
//  PlayerIconButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

// MARK: - PlayerIconButton
struct PlayerIconButton: View {
    let systemName: String
    let badgeText: String?
    let action: (() -> Void)?

    @Environment(\.playerBarStyle) private var style
    @State private var isHovering = false

    init(
        systemName: String,
        badgeText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemName = systemName
        self.badgeText = badgeText
        self.action = action
    }

    var body: some View {
        Button {
            action?()
        } label: {
            Image(systemName: systemName)
                .font(iconFont)
                .foregroundStyle(isHovering ? style.iconHoverColor : style.iconColor)
                .frame(width: iconSize, height: iconSize)
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
            .frame(width: buttonSize, height: buttonSize, alignment: alignment)
            .overlay(alignment: .topTrailing) {
                if let badgeText {
                    IconCornerBadge(
                        text: badgeText,
                        color: isHovering ? style.iconHoverColor : style.secondaryTextColor,
                        backgroundColor: style.backgroundColor
                    )
                }
            }
            .onHover { isHovering = $0 }
    }

    private var hasBadge: Bool { badgeText != nil }
    private var alignment: Alignment { hasBadge ? .leading : .center }
    private var buttonSize: CGFloat { hasBadge ? 30 : 20 }
    private var iconSize: CGFloat { hasBadge ? 20 : 18 }
    private var iconFont: Font { hasBadge ? .font20 : .font16 }
}

// MARK: - IconCornerBadge
private struct IconCornerBadge: View {
    let text: String
    let color: Color
    let backgroundColor: Color

    var body: some View {
        Text(text)
            .font(.font8)
            .foregroundStyle(color)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, Layout.horizontalInset)
            .background(
                Capsule(style: .continuous)
                    .fill(backgroundColor)
            )
            .offset(x: Layout.xOffset, y: Layout.yOffset)
    }

    private enum Layout {
        static let horizontalInset: CGFloat = 1
        static let xOffset: CGFloat = 7
        static let yOffset: CGFloat = 2
    }
}

#Preview {
    HStack(spacing: 16) {
        PlayerIconButton(systemName: "heart", badgeText: "10w+")
        PlayerIconButton(systemName: "speaker.wave.2")
    }
    .padding()

    let style = PlayerBarStyle.fullPlayer(themeColor: Color.yellow)
    VStack {
        HStack(spacing: 16) {
            PlayerIconButton(systemName: "heart", badgeText: "10w+")
            PlayerIconButton(systemName: "speaker.wave.2")
        }
        .padding()
    }
    .background(style.backgroundColor)
    .environment(\.playerBarStyle, style)
}

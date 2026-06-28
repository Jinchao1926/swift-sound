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

    @State private var isHovering = false

    init(systemName: String, badgeText: String? = nil, action: (() -> Void)? = nil) {
        self.systemName = systemName
        self.badgeText = badgeText
        self.action = action
    }

    var body: some View {
        IconButton(systemName: systemName, font: iconFont, size: iconSize, action: action)
            .frame(width: buttonSize, height: buttonSize, alignment: alignment)
            .overlay(alignment: .topTrailing) {
                if let badgeText {
                    IconCornerBadge(
                        text: badgeText,
                        color: isHovering ? Color.textPrimary : Color.textSecondary
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

    var body: some View {
        Text(text)
            .font(.font8)
            .foregroundStyle(color)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, Layout.horizontalInset)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white)
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
}

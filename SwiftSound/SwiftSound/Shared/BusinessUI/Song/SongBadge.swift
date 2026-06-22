//
//  SongBadge.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct SongBadge: View {
    enum Size {
        case small
        case medium
    }

    let title: String
    let tint: Color
    let isInteractive: Bool
    let size: Size

    @State private var isHovering: Bool = false
    private var isHoverInteractive: Bool { isInteractive && isHovering }

    init(_ title: String, tint: Color, size: Size = .small, isInteractive: Bool = false) {
        self.title = title
        self.tint = tint
        self.size = size
        self.isInteractive = isInteractive
    }

    var body: some View {
        Text(title)
            .font(style.font)
            .foregroundStyle(tint)
            .lineLimit(1)
            .padding(.horizontal, style.horizontalPadding)
            .frame(height: style.height)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .fill(isHoverInteractive ? tint.opacity(0.12) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .stroke(tint.opacity(0.8), lineWidth: style.strokeWidth)
            )
            .contentShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
            .pointerStyle(isHoverInteractive ? .link : .default)
            .onHover { isHovering = $0 }
    }

    private var style: Style {
        switch size {
        case .small:
            Style(
                font: .font9,
                horizontalPadding: 2,
                height: 12,
                cornerRadius: 2,
                strokeWidth: 0.5
            )
        case .medium:
            Style(
                font: .font11,
                horizontalPadding: 2,
                height: 15,
                cornerRadius: 3,
                strokeWidth: 0.8
            )
        }
    }

    private struct Style {
        let font: Font
        let horizontalPadding: CGFloat
        let height: CGFloat
        let cornerRadius: CGFloat
        let strokeWidth: CGFloat
    }
}

#Preview {
    VStack {
        SongBadges.mv
        SongBadges.vip
        SongBadges.original

        SongBadges.hiRes
        SongBadges.sq
        SongBadges.hq
    }
    .frame(width: 100, height: 200)
}

//
//  SongBadge.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct SongBadge: View {
    let title: String
    let tint: Color
    let isInteractive: Bool

    @State private var isHovering: Bool = false
    private var isHoverInteractive: Bool { isInteractive && isHovering }

    init(_ title: String, tint: Color, isInteractive: Bool = false) {
        self.title = title
        self.tint = tint
        self.isInteractive = isInteractive
    }

    var body: some View {
        Text(isInteractive ? title + ">" : title)
            .font(.font9)
            .foregroundStyle(tint)
            .lineLimit(1)
            .padding(.horizontal, 2)
            .frame(height: 12)
            .background(
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(isHoverInteractive ? tint.opacity(0.12) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .stroke(tint.opacity(0.8), lineWidth: 0.5)
            )
            .contentShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
            .pointerStyle(isHoverInteractive ? .link : .default)
            .onHover { isHovering = $0 }
    }
}

#Preview {
    VStack {
        SongBadges.hiRes

        SongBadges.sq

        SongBadges.mv

        SongBadges.vip

        SongBadges.original
    }
    .frame(width: 100, height: 200)
}

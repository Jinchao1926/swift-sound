//
//  RoundedButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/21.
//

import SwiftUI

struct RoundedButton: View {
    let title: String
    let font: Font
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    @State private var isHovering = false

    init(
        _ title: String,
        font: Font = .font16,
        width: CGFloat,
        height: CGFloat,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.font = font
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundStyle(Color.accentPrimary)
                .frame(width: width, height: height)
        }
        .buttonStyle(.plain)
        .background(
            Capsule(style: .continuous)
                .fill(isHovering ? Color.accentPrimary.opacity(0.08) : Color.clear)
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.accentPrimary.opacity(0.42), lineWidth: 1)
        )
        .contentShape(Capsule(style: .continuous))
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }
}

#Preview {
    RoundedButton("发现音乐", width: 130, height: 40) {}
        .padding()
}

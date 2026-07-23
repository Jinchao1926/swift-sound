//
//  SelectableCapsule.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import SwiftUI

struct SelectableCapsule: View {
    let title: String
    let font: Font
    let isSelected: Bool
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    @State private var isHovering = false

    init(
        _ title: String,
        isSelected: Bool,
        font: Font = .font14,
        width: CGFloat = 80,
        height: CGFloat = 33,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.font = font
        self.isSelected = isSelected
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundStyle(foregroundColor)
                .frame(width: width, height: height)
        }
        .buttonStyle(.plain)
        .background(
            Capsule(style: .continuous)
                .fill(backgroundColor)
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .contentShape(Capsule(style: .continuous))
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }

    private var isActive: Bool { isSelected || isHovering }

    private var foregroundColor: Color {
        isActive ? Color.accentPrimary : Color.textPrimary
    }

    private var backgroundColor: Color {
        isActive ? Color.accentPrimary.opacity(0.08) : .white
    }

    private var borderColor: Color {
        isActive  ? Color.accentPrimary.opacity(0.12) : .divider
    }
}

#Preview {
    @Previewable @State var selected = "全部"
    let items = ["全部", "男歌手", "女歌手"]

    HStack(spacing: 14) {
        ForEach(items, id: \.self) { item in
            SelectableCapsule(item, isSelected: selected == item) {
                selected = item
            }
        }
    }
    .padding()
    .background(Color.surfacePrimary)
}

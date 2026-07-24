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
        Text(title)
            .font(font)
            .foregroundStyle(foregroundColor)
            .frame(width: width, height: height)
            .background(
                Capsule(style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .contentShape(Rectangle())
            // macOS 上 plain Button 需要完整的 mouseDown -> mouseUp tracking 才会触发 action；
            // 放在 ScrollView/复杂层级里时，这个序列可能被滚动手势竞争或视图重建打断。
            // 这里是自绘筛选胶囊，用高优先级 TapGesture 直接接管点击更稳定。
            .highPriorityGesture(
                TapGesture().onEnded(action)
            )
            .onHover { isHovering = $0 }
            .pointerStyle(.link)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(title)
            .accessibilityAddTraits(.isButton)
            .accessibilityAction(named: title, action)
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

//
//  CarouselControls.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

/// Carousel 两侧的单向翻页按钮。
struct CarouselArrowButton: View {
    let systemName: String
    let isVisible: Bool
    let isEnabled: Bool
    let action: () -> Void

    init(
        systemName: String,
        isVisible: Bool = true,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.isVisible = isVisible
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: guardedAction) {
            Image(systemName: systemName)
                .font(.font14)
                .foregroundStyle(isEnabled ? Color.textPrimary : Color.textSecondary.opacity(0.45))
                .frame(width: CarouselLayoutMetrics.navigationControlWidth)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!canInteract)
        .opacity(isVisible ? 1 : 0)
        .pointerStyle(canInteract ? .link : .default)
        .animation(.easeInOut(duration: 0.15), value: isVisible)
    }

    private var canInteract: Bool {
        isVisible && isEnabled
    }

    private func guardedAction() {
        guard canInteract else { return }
        action()
    }
}

/// 显示当前逻辑页码的分页指示器。
struct CarouselPageIndicator: View {
    let pageCount: Int
    let currentPageIndex: Int

    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule(style: .continuous)
                    .fill(index == currentPageIndex ? Color.textSecondary.opacity(0.55) : Color.divider)
                    .frame(width: index == currentPageIndex ? 14 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: currentPageIndex)
            }
        }
        .frame(height: 14)
        .frame(maxWidth: .infinity)
    }
}

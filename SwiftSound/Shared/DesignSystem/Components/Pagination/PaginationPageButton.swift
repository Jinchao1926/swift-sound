//
//  PaginationPageButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/24.
//

import SwiftUI

struct PaginationPageButton: View {
    let page: Int
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void

    @State private var isHovering = false

    private var isActive: Bool {
        isSelected || isHovering
    }

    var body: some View {
        Button {
            guard !isSelected else { return }
            action()
        } label: {
            Text(page.formatted())
                .font(.font12.weight(.medium))
                .foregroundStyle(isActive ? Color.textPrimary : Color.textSecondary)
                .frame(width: PaginationLayout.Control.itemWidth, height: PaginationLayout.Control.itemHeight)
                .background(isActive ? Color.surfaceHover : Color.clear)
                .contentShape(Rectangle())
                .rounded()
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .onHover { isHovering = $0 }
        .pointerStyle(isEnabled && !isSelected ? .link : .default)
    }
}

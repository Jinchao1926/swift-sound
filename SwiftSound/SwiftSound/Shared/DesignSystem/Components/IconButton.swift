//
//  IconButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import SwiftUI

struct IconButton: View {
    let systemName: String
    let font: Font
    let size: CGFloat
    let action: (() -> Void)?

    @State private var isHovering = false

    init(
        systemName: String,
        font: Font = .font14,
        size: CGFloat = 20,
        action: (() -> Void)? = nil
    ) {
        self.systemName = systemName
        self.font = font
        self.size = size
        self.action = action
    }

    var body: some View {
        Button {
            action?()
        } label: {
            Image(systemName: systemName)
                .font(font)
                .foregroundStyle(isHovering ? Color.textPrimary : Color.textSecondary)
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }
}

#Preview {
    IconButton(systemName: "envelope")
        .padding()
}

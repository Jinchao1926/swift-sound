//
//  IconButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import SwiftUI

struct IconButton: View {
    let systemName: String
    let font: Font?

    @State private var isHovering = false

    init(systemName: String, font: Font? = .font14) {
        self.systemName = systemName
        self.font = font
        self.isHovering = isHovering
    }

    var body: some View {
        Button {} label: {
            Image(systemName: systemName)
                .font(font)
                .foregroundStyle(isHovering ? Color.textPrimary : Color.textSecondary)
                .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }
}

#Preview {
    IconButton(systemName: "envelope")
}

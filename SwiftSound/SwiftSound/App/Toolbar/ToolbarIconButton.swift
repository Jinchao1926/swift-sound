//
//  ToolbarIconButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import SwiftUI

struct ToolbarIconButton: View {
    let systemName: String

    @State private var isHovering = false

    var body: some View {
        Button {} label: {
            Image(systemName: systemName)
                .font(.font14)
                .foregroundStyle(isHovering ? Color.textPrimary : Color.textSecondary)
                .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }
}

#Preview {
    ToolbarIconButton(systemName: "envelope")
}

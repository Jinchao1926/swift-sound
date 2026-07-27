//
//  View+Rounded.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import SwiftUI

extension View {
    func roundedBackground(
        radius: CGFloat = 6,
        fill: some ShapeStyle,
        stroke: Color = Color.divider,
        lineWidth: CGFloat = 1
    ) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(fill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(stroke, lineWidth: lineWidth)
        )
    }

    func rounded(radius: CGFloat = 6) -> some View {
        self.clipShape(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
        )
        .contentShape(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
        )
    }
}

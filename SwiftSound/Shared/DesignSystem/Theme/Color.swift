//
//  Color.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

extension Color {
    /// red
    static let accentPrimary = Color(hex: 0xFD3D4F)

    static let surfacePrimary = Color(hex: 0xF7F9FC)
    static let surfaceSecondary = Color(hex: 0xEFF3F6)
    static let surfaceHover = Color(hex: 0xE3E8EC)

    static let textPrimary = Color(hex: 0x283248)
    static let textSecondary = Color(hex: 0x787F8E)
    static let textTertiary = Color(hex: 0x9A98A3)

    static let textPrimaryOnDark = Color.white.opacity(0.92)
    static let textSecondaryOnDark = Color.white.opacity(0.48)
    static let textTertiaryOnDark = Color.white.opacity(0.28)

    static let divider = Color(hex: 0xE0E6ED)
    static let scrollIndicator = Color(hex: 0xE1E5E9)
}

extension Color {
    init(hex: Int) {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = (hex & 0xFF)

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0)
    }
}

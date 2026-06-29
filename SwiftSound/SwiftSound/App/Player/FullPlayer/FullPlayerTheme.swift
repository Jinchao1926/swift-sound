//
//  FullPlayerTheme.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/28.
//

import SwiftUI

struct FullPlayerTheme {
    let themeColor: Color?

    var background: LinearGradient {
        LinearGradient(
            colors: [
                topBackground,
                middleBackground,
                bottomBackground
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var playerBarStyle: PlayerBarStyle {
        .fullPlayer(themeColor: themeColor)
    }

    private var topBackground: Color {
        guard let themeColor else {
            return Color(hex: 0x1B1B1B)
        }

        return themeColor.mix(with: Color(hex: 0x101010), by: Blend.topBlackAmount)
    }

    private var middleBackground: Color {
        guard let themeColor else {
            return Color(hex: 0x101010)
        }

        return themeColor.mix(with: Color(hex: 0x101010), by: Blend.middleBlackAmount)
    }

    private var bottomBackground: Color {
        guard let themeColor else {
            return Color(hex: 0x0F0F0F)
        }

        return themeColor.mix(with: Color(hex: 0x0F0F0F), by: Blend.bottomBlackAmount)
    }

    private enum Blend {
        static let topBlackAmount = 0.18
        static let middleBlackAmount = 0.26
        static let bottomBlackAmount = 0.34
    }
}

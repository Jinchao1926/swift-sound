//
//  PlayerBarStyle.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/28.
//

import SwiftUI

struct PlayerBarStyle {
    enum Variant {
        case compact
        case fullPlayer
    }

    let variant: Variant
    let themeColor: Color?

    static let compact = PlayerBarStyle(variant: .compact, themeColor: nil)

    static func fullPlayer(themeColor: Color?) -> PlayerBarStyle {
        PlayerBarStyle(variant: .fullPlayer, themeColor: themeColor)
    }
}

extension PlayerBarStyle {
    var isDark: Bool { variant == .fullPlayer }
    var showsArtwork: Bool { variant == .compact }
    var accentColor: Color {
        if let themeColor {
            return themeColor
        }

        return isDark ? Color.white.opacity(0.42) : .accentPrimary
    }

    var backgroundColor: Color {
        guard isDark else { return .white }

        guard themeColor != nil else { return Color(hex: 0x151515) }

        return accentColor.mix(with: Color(hex: 0x111111), by: Blend.barBlackAmount)
    }

    var primaryTextColor: Color { isDark ? Color.white.opacity(0.94) : .textPrimary }
    var secondaryTextColor: Color { isDark ? Color.white.opacity(0.56) : .textSecondary }
    var iconColor: Color { isDark ? Color.white.opacity(0.52) : .textSecondary }
    var iconHoverColor: Color { isDark ? Color.white.opacity(0.82) : .textPrimary }

    var playButtonForegroundColor: Color { isDark ? Color.white.opacity(0.92) : .white }
    var playButtonBackgroundColor: Color {
        guard isDark else { return .accentPrimary }

        guard themeColor != nil else { return Color(hex: 0x2A2A2A) }

        return accentColor.mix(with: Color(hex: 0x252525), by: Blend.playButtonBlackAmount)
    }

    var playButtonHoverBackgroundColor: Color {
        guard isDark else {
            return Color.accentPrimary.mix(with: .black, by: 0.12)
        }

        guard themeColor != nil else { return Color(hex: 0x343434) }

        return accentColor.mix(with: Color(hex: 0x303030), by: Blend.playButtonHoverBlackAmount)
    }

    var progressTrackColor: Color { isDark ? Color.white.opacity(0.14) : Color.divider.opacity(0.62) }
    var progressLabelBackgroundColor: Color { isDark ? .black : .white }
    var progressLabelTextColor: Color { primaryTextColor }
    var volumePanelBackgroundColor: Color { isDark ? Color(hex: 0x34343E) : .white }

    private enum Blend {
        static let barBlackAmount = 0.42
        static let playButtonBlackAmount = 0.54
        static let playButtonHoverBlackAmount = 0.44
    }
}

private struct PlayerBarStyleKey: EnvironmentKey {
    static let defaultValue = PlayerBarStyle.compact
}

extension EnvironmentValues {
    var playerBarStyle: PlayerBarStyle {
        get { self[PlayerBarStyleKey.self] }
        set { self[PlayerBarStyleKey.self] = newValue }
    }
}

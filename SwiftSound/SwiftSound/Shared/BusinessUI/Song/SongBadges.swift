//
//  SongBadges.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/17.
//

import SwiftUI

enum SongBadges {
    static var mv: SongBadge {
        SongBadge("MV>", tint: Color.accentPrimary, isInteractive: true)
    }

    static var vip: SongBadge {
        SongBadge("VIP", tint: Color.accentPrimary)
    }

    static var original: SongBadge {
        SongBadge("原唱", tint: Color.accentPrimary)
    }

    static var hiRes: SongBadge {
        SongBadge("Hi-Res", tint: Color(hex: 0xD3A03B))
    }

    static var sq: SongBadge {
        SongBadge("SQ", tint: Color(hex: 0xD3A03B))
    }

    static func quality(isHiRes: Bool) -> SongBadge {
        isHiRes ? hiRes : sq
    }

    static var hq: SongBadge {
        SongBadge("极高", tint: Color.textSecondary, size: .medium, isInteractive: true)
    }
}

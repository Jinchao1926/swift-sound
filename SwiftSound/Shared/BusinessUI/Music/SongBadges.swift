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

    static var immersive: SongBadge {
        SongBadge("沉浸声", tint: Color(hex: 0xD3A03B))
    }

    static var master: SongBadge {
        SongBadge("超清母带", tint: Color(hex: 0xD3A03B))
    }

    static var unavailable: SongBadge {
        SongBadge("无音源", tint: Color.textSecondary)
    }

    static var sq: SongBadge {
        SongBadge("SQ", tint: Color(hex: 0xD3A03B))
    }

    static func quality(_ kind: SongQualityBadgeKind) -> SongBadge {
        switch kind {
        case .hiRes:
            return hiRes
        case .sq:
            return sq
        case .immersive:
            return immersive
        case .jymaster:
            return master
        case .unavailable:
            return unavailable
        }
    }

    static var hq: SongBadge {
        SongBadge("极高", tint: Color.textSecondary, size: .medium, isInteractive: true)
    }
}

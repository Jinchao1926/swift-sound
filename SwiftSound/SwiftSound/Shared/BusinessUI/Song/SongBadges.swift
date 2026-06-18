//
//  SongBadges.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/17.
//

import SwiftUI

enum SongBadges {
    static var hiRes: SongBadge {
        SongBadge("Hi-Res", tint: Color(hex: 0xD3A03B))
    }

    static var sq: SongBadge {
        SongBadge("SQ", tint: Color(hex: 0xD3A03B))
    }

    static var mv: SongBadge {
        SongBadge("MV", tint: Color(hex: 0xFF817F), isInteractive: true)
    }

    static var vip: SongBadge {
        SongBadge("VIP", tint: Color(hex: 0xFF817F))
    }

    static var original: SongBadge {
        SongBadge("原唱", tint: Color(hex: 0xFF817F))
    }

    static func quality(isHiRes: Bool) -> SongBadge {
        isHiRes ? hiRes : sq
    }
}

//
//  SongTableBadges.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct SongTableBadges: View {
    let row: SongTableRow

    var body: some View {
        if let qualityBadgeKind = row.song.qualityBadgeKind {
            SongBadges.quality(qualityBadgeKind)
        }

        if row.song.requiresVIP {
            SongBadges.vip
        }

        if row.song.hasMV {
            SongBadges.mv
        }
    }
}

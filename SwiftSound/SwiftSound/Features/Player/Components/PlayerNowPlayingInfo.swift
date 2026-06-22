//
//  PlayerNowPlayingInfo.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct PlayerNowPlayingInfo: View {
    let song: Song?

    private var title: String { song?.name ?? "他不爱我" }
    private var artistName: String { song?.artistName ?? "莫文蔚" }
    private var showsVIPBadge: Bool { song?.requiresVIP == true }

    private var titleMaxWidth: CGFloat {
        guard showsVIPBadge else { return Layout.maxWidth }
        return Layout.maxWidth - Layout.vipBadgeWidth - Layout.badgeSpacing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.textSpacing) {
            HStack(spacing: Layout.badgeSpacing) {
                PlayerMarqueeText(
                    title,
                    maxWidth: titleMaxWidth
                )

                if showsVIPBadge {
                    SongBadges.vip
                }
            }

            AdaptiveText(
                artistName,
                font: .font15,
                foregroundColor: .textSecondary,
                maxWidth: Layout.maxWidth
            )
        }
    }

    private enum Layout {
        static let maxWidth: CGFloat = 185
        static let vipBadgeWidth: CGFloat = 18
        static let textSpacing: CGFloat = 6
        static let badgeSpacing: CGFloat = 4
    }
}

#Preview {
    PlayerNowPlayingInfo(song: nil)
        .padding()
}

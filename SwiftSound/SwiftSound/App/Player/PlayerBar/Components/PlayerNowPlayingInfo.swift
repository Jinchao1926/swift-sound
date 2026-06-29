//
//  PlayerNowPlayingInfo.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct PlayerNowPlayingInfo: View {
    let song: Song

    @Environment(\.playerBarStyle) private var style

    private var title: String { song.name }
    private var artistName: String { song.artistName ?? "" }
    private var showsVIPBadge: Bool { song.requiresVIP }

    private var titleMaxWidth: CGFloat {
        guard showsVIPBadge else { return Layout.maxWidth }
        return Layout.maxWidth - Layout.vipBadgeWidth - Layout.badgeSpacing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.textSpacing) {
            HStack(spacing: Layout.badgeSpacing) {
                PlayerMarqueeText(
                    title,
                    foregroundColor: style.primaryTextColor,
                    maxWidth: titleMaxWidth
                )

                if showsVIPBadge {
                    SongBadges.vip
                }
            }

            AdaptiveText(
                artistName,
                font: .font15,
                foregroundColor: style.secondaryTextColor,
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
    PlayerNowPlayingInfo(song: .preview)
        .padding()

    let style = PlayerBarStyle.fullPlayer(themeColor: Color.yellow)
    VStack {
        PlayerNowPlayingInfo(song: .preview)
            .padding()
    }
    .background(style.backgroundColor)
    .environment(\.playerBarStyle, style)
}

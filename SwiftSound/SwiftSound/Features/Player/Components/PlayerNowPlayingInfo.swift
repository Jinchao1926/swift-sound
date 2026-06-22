//
//  PlayerNowPlayingInfo.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct PlayerNowPlayingInfo: View {
    let song: Song?

    private var title: String {
        song?.name ?? "你才会这样的想起我"
    }

    private var artistName: String {
        song?.artistName ?? "彭家丽"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.textSpacing) {
            HStack(spacing: Layout.badgeSpacing) {
                PlayerMarqueeText(
                    title,
                    maxWidth: Layout.titleMaxWidth
                )

                SongBadges.vip
            }

            Text(artistName)
                .font(.font16)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
                .frame(maxWidth: Layout.titleMaxWidth, alignment: .leading)
        }
    }

    private enum Layout {
        static let titleMaxWidth: CGFloat = 180
        static let textSpacing: CGFloat = 7
        static let badgeSpacing: CGFloat = 4
    }
}

#Preview {
    PlayerNowPlayingInfo(song: nil)
        .frame(width: 224, alignment: .leading)
        .padding()
}

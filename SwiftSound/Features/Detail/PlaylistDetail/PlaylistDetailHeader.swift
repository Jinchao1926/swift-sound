//
//  PlaylistDetailHeader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import SwiftUI

struct PlaylistDetailHeader: View {
    let playlist: Playlist
    let onPlayAll: () -> Void

    var body: some View {
        HStack(spacing: Layout.spacing) {
            RemoteImage(url: URL(string: playlist.coverImgUrl))
                .frame(width: Layout.size, height: Layout.size)
                .rounded(radius: Layout.cornerRadius)
                .overlay(alignment: .topTrailing) {
                    PlayCountBadge(count: playlist.playCount)
                        .padding(Layout.badgePadding)
                }

            VStack(alignment: .leading, spacing: 0) {
                Text(playlist.name)
                    .font(.font18)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                Text(playlist.description)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.vertical, Layout.descriptionPadding)

                HStack(spacing: Layout.creatorSpacing) {
                    HStack(spacing: Layout.creatorSpacing / 2) {
                        Avatar(url: playlist.creator.avatarURL, size: Layout.avatarSize)

                        Text(playlist.creator.nickname)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .routeLink(to: .user(id: playlist.creator.userId))

                    Text("\(playlist.updateTime.formattedMillisecondsYearMonthDay()) 更新")
                        .foregroundStyle(Color.textTertiary)
                }
                .font(.font13)

                Spacer()

                HStack(spacing: Layout.buttonSpacing) {
                    ActionButton(
                        "播放全部",
                        systemName: "play.fill",
                        variant: .primary
                    ) {
                        onPlayAll()
                    }
                    ActionButton(playlist.subscribedCount.formattedCount(), systemName: "plus.square.fill" ) {}
                    ActionButton("下载", systemName: "arrow.down.square.fill" ) {}
                    ActionButton(systemName: "ellipsis" ) {}
                }
            }

            Spacer()
        }
        .frame(height: Layout.size)
    }
}

private extension PlaylistDetailHeader {
    enum Layout {
        static let spacing: CGFloat = 25
        static let badgePadding: CGFloat = 10
        static let size: CGFloat = 170
        static let cornerRadius: CGFloat = 8

        static let descriptionPadding: CGFloat = 16
        static let creatorSpacing: CGFloat = 10
        static let avatarSize: CGFloat = 25

        static let buttonSpacing: CGFloat = 12
    }
}

#Preview {
    VStack {
        PlaylistDetailHeader(playlist: .preview, onPlayAll: {})
    }
    .padding()
}

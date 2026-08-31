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
            RemoteImage(url: playlist.coverURL)
                .frame(width: Layout.size, height: Layout.size)
                .rounded(radius: Layout.cornerRadius)
                .overlay(alignment: .topTrailing) {
                    PlayCountBadge(count: playlist.playCount)
                        .padding(Layout.badgeInset)
                }

            VStack(alignment: .leading, spacing: Layout.detailSpacing) {
                Text(playlist.name)
                    .font(.font18)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                if let description = playlist.description?.replacingOccurrences(of: "\n", with: "") {
                    Text(description)
                        .font(.font14)
                        .foregroundStyle(Color.textSecondary)
                }

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
                .font(.font12)

                Spacer()

                HStack(spacing: Layout.buttonSpacing) {
                    MusicActionButtons.playAll {
                        onPlayAll()
                    }
                    MusicActionButtons.favorite(playlist.subscribedCount.formattedCount()) {}
                    MusicActionButtons.download {}
                    MusicActionButtons.more {}
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
        static let badgeInset: CGFloat = 10
        static let size: CGFloat = 170
        static let cornerRadius: CGFloat = 8

        static let detailSpacing: CGFloat = 16
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

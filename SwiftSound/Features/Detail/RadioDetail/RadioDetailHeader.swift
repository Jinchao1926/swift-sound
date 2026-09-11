//
//  RadioDetailHeader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import SwiftUI

struct RadioDetailHeader: View {
    let radio: Radio?
    let onPlayAll: () -> Void
    
    var body: some View {
        HStack(spacing: Layout.spacing) {
            RemoteImage(url: radio?.imageURL)
                .frame(width: Layout.size, height: Layout.size)
                .rounded(radius: Layout.cornerRadius)
                .overlay(alignment: .topTrailing) {
                    if let playCount = radio?.playCount, playCount > 0 {
                        PlayCountBadge(count: playCount)
                            .padding(Layout.badgeInset)
                    }
                }

            if let radio {
                VStack(alignment: .leading, spacing: Layout.detailSpacing) {
                    Text(radio.name)
                        .font(.font18)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)

                    Text(radio.desc)
                        .font(.font14)
                        .foregroundStyle(Color.textSecondary)

                    HStack(spacing: Layout.creatorSpacing) {
                        if let dj = radio.dj {
                            creatorView(for: dj)
                        }

                        Rectangle()
                            .fill(Color.divider)
                            .frame(width: 1, height: Layout.divider)
                        tagView(for: radio.category)
                        tagView(for: radio.secondCategory)
                    }

                    Spacer()

                    HStack(spacing: Layout.buttonSpacing) {
                        MusicActionButtons.playAll {
                            onPlayAll()
                        }
                        MusicActionButtons.favorite(radio.subCount.formattedCount()) {}
                        MusicActionButtons.more {}
                    }
                }
            }

            Spacer()
        }
        .frame(height: Layout.size)
    }
}

private extension RadioDetailHeader {
    func creatorView(for user: User) -> some View {
        HStack(spacing: Layout.creatorSpacing / 2) {
            Avatar(url: user.avatarURL, size: Layout.avatarSize)
                .overlay(alignment: .bottomTrailing) {
                    if let avatarDetail = user.avatarDetail {
                        Avatar(
                            url: avatarDetail.avatarURL,
                            size: Layout.overlaySize
                        )
                    }
                }

            Text(user.nickname)
                .foregroundStyle(Color.textSecondary)
        }
        .routeLink(to: .user(id: user.userId))
    }

    func tagView(for tag: String) -> some View {
        Text(tag)
            .font(.font12)
            .foregroundStyle(Color.textSecondary)
            .padding(Layout.tagInset)
            .background(
                RoundedRectangle(cornerRadius: Layout.tagRadius, style: .continuous)
                    .fill(Color.surfaceSecondary)
            )
    }
}

private extension RadioDetailHeader {
    enum Layout {
        static let spacing: CGFloat = 25
        static let badgeInset: CGFloat = 10
        static let size: CGFloat = 170
        static let cornerRadius: CGFloat = 8

        static let detailSpacing: CGFloat = 16
        static let creatorSpacing: CGFloat = 10
        static let avatarSize: CGFloat = 25
        static let overlaySize: CGFloat = 10

        static let divider: CGFloat = 12
        static let tagInset: CGFloat = 3
        static let tagRadius: CGFloat = 3

        static let buttonSpacing: CGFloat = 12
    }
}

#Preview {
    VStack {
        RadioDetailHeader(radio: .preview1, onPlayAll: {})
    }
    .padding()
}

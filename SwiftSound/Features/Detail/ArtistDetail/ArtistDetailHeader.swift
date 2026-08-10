//
//  ArtistDetailHeader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

struct ArtistDetailHeader: View {
    let detail: ArtistDetail
    let onPlayAll: () -> Void

    var body: some View {
        HStack(spacing: Layout.headerSpacing) {
            RemoteImage(url: detail.artist.avatarURL)
                .frame(width: Layout.avatarSize, height: Layout.avatarSize)
                .rounded(radius: Layout.avatarSize / 2)

            VStack(alignment: .leading, spacing: 0) {
                Text(detail.artist.name)
                    .font(.font18)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                HStack(spacing: Layout.metadataSpacing) {
                    SeparatedText(detail.artist.aliases)

                    if let user = detail.user {
                        RouteLink(route: .user(id: user.userId)) {
                            Text("个人页 >")
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
                .padding(.top, Layout.metadataTopPadding)
                .padding(.bottom, Layout.metadataBottomPadding)

                HStack(spacing: Layout.actionSpacing) {
                    ActionButton(
                        "播放全部",
                        systemName: "play.fill",
                        variant: .primary
                    ) {
                        onPlayAll()
                    }

                    ActionButton("关注", systemName: "plus" ) {}
                }
            }

            Spacer()
        }
    }
}

private extension ArtistDetailHeader {
    enum Layout {
        static let headerSpacing: CGFloat = 25
        static let avatarSize: CGFloat = 170
        static let metadataSpacing: CGFloat = 20
        static let metadataTopPadding: CGFloat = 12
        static let metadataBottomPadding: CGFloat = 16
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    ArtistDetailHeader(
        detail: ArtistDetail(artist: .preview, user: nil),
        onPlayAll: {}
    )
}

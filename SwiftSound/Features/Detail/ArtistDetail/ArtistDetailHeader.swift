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
            Avatar(url: detail.artist.avatarURL, size: Layout.avatarSize)

            VStack(alignment: .leading, spacing: 0) {
                Text(detail.artist.name)
                    .font(.font18)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                HStack(spacing: Layout.detailSpacing) {
                    SeparatedText(detail.artist.aliases)

                    if let user = detail.user {
                        RouteLink(route: .user(id: user.userId)) {
                            Text("个人页 >")
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
                .padding(.top, Layout.detailTopInset)
                .padding(.bottom, Layout.detailBottomInset)

                HStack(spacing: Layout.actionSpacing) {
                    MusicActionButtons.playAll {
                        onPlayAll()
                    }

                    MusicActionButtons.follow {}
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
        static let detailSpacing: CGFloat = 20
        static let detailTopInset: CGFloat = 12
        static let detailBottomInset: CGFloat = 16
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    ArtistDetailHeader(
        detail: ArtistDetail(artist: .preview, user: nil),
        onPlayAll: {}
    )
}

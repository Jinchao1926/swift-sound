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
                .padding(.top, Layout.metadataTopInset)
                .padding(.bottom, Layout.metadataBottomInset)

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
        static let metadataSpacing: CGFloat = 20
        static let metadataTopInset: CGFloat = 12
        static let metadataBottomInset: CGFloat = 16
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    ArtistDetailHeader(
        detail: ArtistDetail(artist: .preview, user: nil),
        onPlayAll: {}
    )
}

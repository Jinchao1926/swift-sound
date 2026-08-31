//
//  UserDetailHeader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import SwiftUI

struct UserDetailHeader: View {
    private struct UserFollows {
        let title: String
        let number: Int
    }

    let detail: UserDetail
    var user: User { detail.profile }

    var body: some View {
        HStack(alignment: .top, spacing: Layout.headerSpacing) {
            Avatar(url: user.avatarURL, size: Layout.avatarSize)

            VStack(alignment: .leading, spacing: Layout.detailSpacing) {
                Text(user.nickname)
                    .font(.font20)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                identityRow
                followsRow
                VStack(alignment: .leading, spacing: Layout.signatureSpacing) {
                    signatureRow
                    locationRow
                }
                actionRow
            }

            Spacer()
        }
        .padding(.top, Layout.headerPadding)
    }

    private var identityRow: some View {
        HStack(spacing: Layout.identitySpacing) {
            if user.isVIP {
                VIPLevelView()
            }

            if let identify = detail.identify {
                IdentifyView(identify: identify)
            }

            LevelView(level: detail.level)
            GenderView(gender: user.gender)
        }
    }

    @ViewBuilder
    private var followsRow: some View {
        let follows = [
            UserFollows(title: "关注", number: user.follows ?? 0),
            UserFollows(title: "粉丝", number: user.followeds ?? 0)
        ].filter { $0.number > 0 }

        if !follows.isEmpty {
            HStack(spacing: Layout.followSpacing) {
                ForEach(Array(follows.enumerated()), id: \.offset) { index, follow in
                    if index > 0 {
                        Rectangle()
                            .fill(Color.divider)
                            .frame(width: 1, height: Layout.separatorHeight)
                    }

                    Text("\(follow.title) \(follow.number)")
                }
            }
            .font(.font15.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
        }
    }

    @ViewBuilder
    private var signatureRow: some View {
        if let signature = user.signature, !signature.isEmpty {
            Text("简介：\(signature)")
                .font(.font13)
                .foregroundStyle(Color.textSecondary)
        }
    }

    @ViewBuilder
    private var locationRow: some View {
        if let region = UserRegionFormatter.location(
            provinceCode: user.province,
            cityCode: user.city
        ) {
            Text("地区：\(region)")
                .font(.font13)
                .foregroundStyle(Color.textTertiary)
        }
    }

    @ViewBuilder
    private var actionRow: some View {
        let artistID = detail.profile.artistId

        HStack(spacing: Layout.actionSpacing) {
            if let artistID {
                ActionButton(
                    "歌手页",
                    systemName: "person",
                    variant: .primary,
                    action: {}
                )
                .routeLink(to: .artist(id: artistID))
            }

            ActionButton(
                "关注",
                systemName: "plus",
                variant: artistID == nil ? .primary : .secondary,
                action: {}
            )

            MusicActionButtons.message {}
            MusicActionButtons.more {}
        }
    }
}

private extension UserDetailHeader {
    enum Layout {
        static let headerPadding: CGFloat = 10
        static let headerSpacing: CGFloat = 25
        static let avatarSize: CGFloat = 168

        static let detailSpacing: CGFloat = 12
        static let signatureSpacing: CGFloat = 10
        static let identitySpacing: CGFloat = 4
        static let followSpacing: CGFloat = 10
        static let separatorHeight: CGFloat = 16
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    UserDetailHeader(detail: .preview)
}

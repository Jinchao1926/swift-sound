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
        HStack(spacing: Layout.headerSpacing) {
            Avatar(url: user.avatarURL, size: Layout.avatarSize)

            VStack(alignment: .leading, spacing: Layout.detailSpacing) {
                Text(user.nickname)
                    .font(.font18)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                identityRow
                followsRow
                locationRow
                actionRow
            }

            Spacer()
        }
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

                    Text("\(follow.title) \(follow.number.formattedCount())")
                }
            }
            .font(.font14.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
        }
    }

    private var locationRow: some View {
        let region = UserRegionFormatter.location(
            provinceCode: user.province,
            cityCode: user.city
        )
        return Text("地区：\(region)")
            .font(.font13)
            .foregroundStyle(Color.textTertiary)
    }

    private var actionRow: some View {
        HStack(spacing: Layout.actionSpacing) {
            let isArtist = detail.identify != nil
            if isArtist {
                ActionButton(
                    "歌手页",
                    systemName: "person",
                    variant: .primary,
                    action: {}
                )
            }
            ActionButton(
                "关注",
                systemName: "plus",
                variant: isArtist ? .secondary : .primary,
                action: {}
            )
            MusicActionButtons.follow {}
            MusicActionButtons.message {}
            MusicActionButtons.more {}
        }
    }
}

private extension UserDetailHeader {
    enum Layout {
        static let headerSpacing: CGFloat = 25
        static let avatarSize: CGFloat = 170

        static let detailSpacing: CGFloat = 12
        static let identitySpacing: CGFloat = 4
        static let followSpacing: CGFloat = 10
        static let separatorHeight: CGFloat = 16
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    UserDetailHeader(detail: .preview)
}

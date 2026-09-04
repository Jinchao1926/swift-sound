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

    let detail: UserDetail?

    var body: some View {
        HStack(alignment: .top, spacing: Layout.headerSpacing) {
            Avatar(url: detail?.profile.avatarURL, size: Layout.avatarSize)

            if let detail {
                VStack(alignment: .leading, spacing: Layout.detailSpacing) {
                    Text(detail.profile.nickname)
                        .font(.font20)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)

                    identityRow(for: detail)
                    followsRow(for: detail)
                    VStack(alignment: .leading, spacing: Layout.signatureSpacing) {
                        signatureRow(for: detail)
                        locationRow(for: detail)
                    }
                    actionRow(for: detail)
                }
            }

            Spacer()
        }
    }

    private func identityRow(for detail: UserDetail) -> some View {
        HStack(spacing: Layout.identitySpacing) {
            if detail.profile.isVIP {
                VIPLevelView()
            }

            if let identify = detail.identify {
                IdentifyView(identify: identify)
            }

            LevelView(level: detail.level)
            GenderView(gender: detail.profile.gender)
        }
    }

    @ViewBuilder
    private func followsRow(for detail: UserDetail) -> some View {
        let follows = [
            UserFollows(title: "关注", number: detail.profile.follows ?? 0),
            UserFollows(title: "粉丝", number: detail.profile.followeds ?? 0)
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
    private func signatureRow(for detail: UserDetail) -> some View {
        if let signature = detail.profile.signature, !signature.isEmpty {
            Text("简介：\(signature)")
                .font(.font13)
                .foregroundStyle(Color.textSecondary)
        }
    }

    @ViewBuilder
    private func locationRow(for detail: UserDetail) -> some View {
        if let region = UserRegionFormatter.location(
            provinceCode: detail.profile.province,
            cityCode: detail.profile.city
        ) {
            Text("地区：\(region)")
                .font(.font13)
                .foregroundStyle(Color.textTertiary)
        }
    }

    @ViewBuilder
    private func actionRow(for detail: UserDetail) -> some View {
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

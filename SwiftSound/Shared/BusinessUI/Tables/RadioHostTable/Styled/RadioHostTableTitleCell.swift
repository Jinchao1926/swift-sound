//
//  RadioHostTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioHostTableTitleCell: View {
    let imageURL: URL?
    let title: String
    let rankingInfo: any RankingInfoProviding
    let avatarDetail: AvatarDetail?

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            Avatar(url: imageURL, size: Layout.imageSize)
                .overlay(alignment: .bottomTrailing) {
                    if let avatarDetail {
                        Avatar(
                            url: avatarDetail.avatarURL,
                            size: Layout.overlaySize
                        )
                    }
                }

            Text(title)
                .font(.font16)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.trailing, Layout.trailingPadding)
    }
}

private enum Layout {
    static let contentSpacing: CGFloat = 10
    static let trailingPadding: CGFloat = 30

    static let imageSize: CGFloat = 50
    static let imageCornerRadius: CGFloat = 4
    static let overlaySize: CGFloat = 15
}

#Preview {
    VStack {
        RadioHostTableTitleCell(
            imageURL: RadioHostChart.preview.imageURL,
            title: RadioHostChart.preview.nickName,
            rankingInfo: RadioHostChart.preview,
            avatarDetail: RadioHostChart.preview.avatarDetail
        )

        RadioHostTableTitleCell(
            imageURL: RadioHostChart.preview1.imageURL,
            title: RadioHostChart.preview1.nickName,
            rankingInfo: RadioHostChart.preview1,
            avatarDetail: RadioHostChart.preview1.avatarDetail
        )
    }
    .padding()
    .frame(width: 360)
    .background(Color.surfacePrimary)
}

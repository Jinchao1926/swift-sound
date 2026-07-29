//
//  MusicTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct MusicTableTitleCell<Badges: View>: View {
    let imageURL: URL?
    let title: String
    let titleSuffix: String?
    let subTitle: String?
    let badges: Badges

    init(
        imageURL: URL?,
        title: String,
        titleSuffix: String? = nil,
        subTitle: String? = nil,
        @ViewBuilder badges: () -> Badges
    ) {
        self.imageURL = imageURL
        self.title = title
        self.titleSuffix = titleSuffix
        self.subTitle = subTitle
        self.badges = badges()
    }

    var body: some View {
        HStack(spacing: Layout.contentHorizontalInset) {
            RemoteImage(url: imageURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .rounded(radius: Layout.imageCornerRadius)

            VStack(alignment: .leading, spacing: Layout.contentVerticalInset) {
                titleLine
                subTitleLine
            }
        }
    }

    private var titleLine: some View {
        HStack(spacing: Layout.titleInset) {
            Text(title)
                .font(.font14)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            if let titleSuffix {
                Text(titleSuffix)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
    }

    private var subTitleLine: some View {
        HStack(spacing: Layout.badgeSpacing) {
            badges

            if let subTitle {
                Text(subTitle)
                    .font(.font13)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
                    .padding(.leading, Layout.titleInset)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private enum Layout {
    static let contentHorizontalInset: CGFloat = 10
    static let contentVerticalInset: CGFloat = 5

    static let imageSize: CGFloat = 38
    static let imageCornerRadius: CGFloat = 4

    static let titleInset: CGFloat = 6
    static let badgeSpacing: CGFloat = 4
}

#Preview {
    MusicTableTitleCell(
        imageURL: URL(string: Song.preview.album.picUrl),
        title: Song.preview.name,
        titleSuffix: "",
        subTitle: Song.preview.artistName
    ) {
        SongBadges.vip
        SongBadges.mv
    }
    .frame(width: 360)
    .padding()
}

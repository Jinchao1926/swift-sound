//
//  MusicTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

enum MusicTableAction {
    case download
    case addToPlaylist
    case comment
    case more
}

struct MusicTableTitleCell<Badges: View>: View {
    let imageURL: URL?
    let title: String
    let titleSuffix: String?
    let subTitle: String?
    let rowState: SongTableRowState
    let onAction: (MusicTableAction) -> Void
    let badges: Badges

    init(
        imageURL: URL?,
        title: String,
        titleSuffix: String? = nil,
        subTitle: String? = nil,
        rowState: SongTableRowState = .init(),
        onAction: @escaping (MusicTableAction) -> Void = { _ in },
        @ViewBuilder badges: () -> Badges
    ) {
        self.imageURL = imageURL
        self.title = title
        self.titleSuffix = titleSuffix
        self.subTitle = subTitle
        self.rowState = rowState
        self.onAction = onAction
        self.badges = badges()
    }

    var body: some View {
        HStack(spacing: Layout.contentInternalHInset) {
            RemoteImage(url: imageURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .rounded(radius: Layout.imageCornerRadius)

            VStack(alignment: .leading, spacing: Layout.contentInternalVInset) {
                titleLine
                subTitleLine
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if rowState.showsActions {
                MusicTableActionView(onAction: onAction)
            }
        }
        .padding(.trailing, Layout.contentTrailingInset)
    }

    private var titleLine: some View {
        HStack(spacing: Layout.titleInset) {
            Text(title)
                .font(.font14)
                .foregroundStyle(rowState.titleColor)
                .lineLimit(1)

            if let titleSuffix {
                Text(titleSuffix)
                    .font(.font14)
                    .foregroundStyle(rowState.titleSuffixColor)
                    .lineLimit(1)
            }
        }
    }

    private var subTitleLine: some View {
        HStack(spacing: Layout.badgeInset) {
            badges

            if let subTitle {
                Text(subTitle)
                    .font(.font13)
                    .foregroundStyle(rowState.subTitleColor)
                    .lineLimit(1)
                    .padding(.leading, Layout.titleInset)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MusicTableActionView: View {
    let onAction: (MusicTableAction) -> Void

    init(onAction: @escaping (MusicTableAction) -> Void = { _ in }) {
        self.onAction = onAction
    }

    var body: some View {
        HStack(spacing: Layout.actionInset) {
            actionButton(systemName: "arrow.down.circle", title: "下载", action: .download)
            actionButton(systemName: "plus.square", title: "收藏", action: .addToPlaylist)
            actionButton(systemName: "text.bubble", title: "评论", action: .comment)
            actionButton(systemName: "ellipsis", title: "更多", action: .more)
        }
        .layoutPriority(1)
    }

    private func actionButton(systemName: String, title: String, action: MusicTableAction) -> some View {
        IconButton(systemName: systemName, font: .font16, size: Layout.actionSize) {
            onAction(action)
        }
            .help(title)
            .accessibilityLabel(title)
    }
}

private enum Layout {
    static let contentInternalHInset: CGFloat = 10
    static let contentInternalVInset: CGFloat = 5
    static let contentTrailingInset: CGFloat = 30

    static let imageSize: CGFloat = 38
    static let imageCornerRadius: CGFloat = 4

    static let titleInset: CGFloat = 6
    static let badgeInset: CGFloat = 4
    static let actionInset: CGFloat = 12
    static let actionSize: CGFloat = 18
}

#Preview {
    VStack {
        MusicTableTitleCell(
            imageURL: URL(string: Song.preview.album.picUrl),
            title: Song.preview.name,
            titleSuffix: "",
            subTitle: Song.preview.artistName
        ) {
            SongBadges.vip
            SongBadges.mv
        }

        MusicTableTitleCell(
            imageURL: URL(string: Song.preview1.album.picUrl),
            title: Song.preview1.name,
            titleSuffix: "",
            subTitle: Song.preview.artistName,
            rowState: .init(isHovering: true, playbackStatus: .currentPlaying)
        ) {
            SongBadges.vip
            SongBadges.mv
        }
    }
    .padding()
    .frame(width: 360)
    .background(Color.surfacePrimary)
}

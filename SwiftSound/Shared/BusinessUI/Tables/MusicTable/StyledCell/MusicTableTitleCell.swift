//
//  MusicTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct MusicTableTitleCell<Subtitle: View, Actions: View>: View {
    let imageURL: URL?
    let title: String
    let titleSuffix: String?
    let rowState: MusicTableRowState
    let subtitle: Subtitle
    let actions: Actions

    init(
        imageURL: URL?,
        title: String,
        titleSuffix: String? = nil,
        rowState: MusicTableRowState = .init(),
        @ViewBuilder subtitle: () -> Subtitle,
        @ViewBuilder actions: () -> Actions
    ) {
        self.imageURL = imageURL
        self.title = title
        self.titleSuffix = titleSuffix
        self.rowState = rowState
        self.subtitle = subtitle()
        self.actions = actions()
    }

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            RemoteImage(url: imageURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .rounded(radius: Layout.imageCornerRadius)

            VStack(alignment: .leading, spacing: Layout.textSpacing) {
                titleLine
                subtitleLine
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if rowState.showsActions {
                actions
            }
        }
        .padding(.trailing, Layout.trailingPadding)
    }

    private var titleLine: some View {
        HStack(spacing: Layout.titleSpacing) {
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

    private var subtitleLine: some View {
        subtitle
            .font(.font13)
            .foregroundStyle(rowState.subtitleColor)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension MusicTableTitleCell where Subtitle == EmptyView {
    init(
        imageURL: URL?,
        title: String,
        titleSuffix: String? = nil,
        rowState: MusicTableRowState = .init(),
        @ViewBuilder actions: () -> Actions
    ) {
        self.init(
            imageURL: imageURL,
            title: title,
            titleSuffix: titleSuffix,
            rowState: rowState,
            subtitle: { EmptyView() },
            actions: actions
        )
    }
}

private enum Layout {
    static let contentSpacing: CGFloat = 10
    static let textSpacing: CGFloat = 5
    static let trailingPadding: CGFloat = 30

    static let imageSize: CGFloat = 38
    static let imageCornerRadius: CGFloat = 4

    static let titleSpacing: CGFloat = 6
}

#Preview {
    VStack {
        MusicTableTitleCell(
            imageURL: Song.preview.album.imageURL,
            title: Song.preview.name,
            titleSuffix: ""
        ) {
            Text(Song.preview.artistName ?? "")
        } actions: {
            EmptyView()
        }

        MusicTableTitleCell(
            imageURL: Song.preview1.album.imageURL,
            title: Song.preview1.name,
            titleSuffix: "",
            rowState: .init(isHovering: true, playbackStatus: .currentPlaying)
        ) {
            Text(Song.preview.artistName ?? "")
        } actions: {
            EmptyView()
        }
    }
    .padding()
    .frame(width: 360)
    .background(Color.surfacePrimary)
}

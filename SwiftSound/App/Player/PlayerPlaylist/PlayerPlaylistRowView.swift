//
//  PlayerPlaylistRowView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/15.
//

import SwiftUI

struct PlayerPlaylistRowView: View {
    let song: Song
    let isCurrent: Bool
    let controlIcon: PlayableCoverImage.ControlIcon
    let onControlTap: () -> Void
    let onRemove: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            coverImage

            VStack(alignment: .leading, spacing: 5) {
                titleLine
                metadataLine
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()

            trailingView
        }
        .padding(.leading, Layout.leadingInset)
        .padding(.trailing, Layout.trailingInset)
        .frame(height: Layout.height)
        .background(rowBackground)
        .contentShape(Rectangle())
        .onHover { isHovering = $0 }
    }

    private var coverImage: some View {
        PlayableCoverImage(
            url: URL(string: song.album.picUrl),
            imageSize: Layout.coverSize,
            cornerRadius: Layout.coverCornerRadius,
            playButtonFont: .font16,
            playButtonSize: 22,
            animatesHoverEffects: false,
            controlIcon: controlIcon,
            isControlVisible: isHovering,
            onControlTap: onControlTap
        )
    }

    private var titleLine: some View {
        Text(song.name)
            .font(.font16)
            .foregroundStyle(isCurrent ? Color.accentPrimary : Color.textPrimary)
            .lineLimit(1)
            .truncationMode(.tail)
    }

    private var metadataLine: some View {
        HStack(spacing: 4) {
            if song.requiresVIP {
                SongBadges.vip
            }

            if let qualityBadgeKind = song.qualityBadgeKind {
                SongBadges.quality(qualityBadgeKind)
            }

            if song.hasMV {
                SongBadges.mv
            }

            Text(song.artistName ?? "未知歌手")
                .font(.font13)
                .foregroundStyle(isCurrent ? Color.accentPrimary : Color.textSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    @ViewBuilder
    private var trailingView: some View {
        if isHovering {
            actionView
        } else {
            durationView
        }
    }

    private var durationView: some View {
        Text(durationText)
            .font(.font13)
            .foregroundStyle(Color.textSecondary.opacity(0.75))
            .frame(width: Layout.durationWidth, alignment: .trailing)
    }

    private var actionView: some View {
        HStack(spacing: Layout.actionSpacing) {
            IconButton(systemName: "link", font: .font16).help("来源")
            IconButton(systemName: "heart", font: .font16).help("喜欢")
            IconButton(systemName: "plus.square", font: .font16).help("收藏")
            IconButton(systemName: "ellipsis", font: .font16).help("更多")
        }
        .frame(alignment: .trailing)
    }

    private var rowBackground: Color {
        isHovering ? Color(hex: 0xEDEEEF) : .clear
    }

    private var durationText: String {
        Int(song.durationTimeInterval.rounded()).minuteSecondText
    }
}

private extension PlayerPlaylistRowView {
    enum Layout {
        static let height: CGFloat = 64
        static let leadingInset: CGFloat = 20
        static let trailingInset: CGFloat = 10
        static let contentSpacing: CGFloat = 10

        static let coverSize: CGFloat = 48
        static let coverCornerRadius: CGFloat = 6

        static let durationWidth: CGFloat = 42
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    PlayerPlaylistRowView(
        song: .preview,
        isCurrent: true,
        controlIcon: .pause,
        onControlTap: {},
        onRemove: {}
    )
    .frame(width: 470)
    .background(Color.white)
}

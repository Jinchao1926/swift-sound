//
//  FullPlayerSongInfoView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/29.
//

import SwiftUI

struct FullPlayerSongInfoView: View {
    let song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title

            metadata
                .padding(.top, 10)

            tabs
                .padding(.vertical, 20)

            credits

            Spacer(minLength: 0)
        }
    }

    private var title: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(song.name)
                .font(.font18.weight(.semibold))
                .foregroundStyle(Layout.primaryTextColor)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            if song.requiresVIP || song.fee == .limitedFree {
                fullPlayerBadge("VIP")
                fullPlayerBadge("试听")
            }

            if song.hasMV {
                fullPlayerBadge("MV>")
            }
        }
    }

    private var metadata: some View {
        HStack(spacing: 20) {
            metadataItem(title: "专辑", value: song.album.name)
            metadataItem(title: "歌手", value: song.artistName ?? "未知歌手")
            metadataItem(title: "来源", value: song.artistName ?? "未知来源")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metadataItem(title: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text("\(title):")
                .foregroundStyle(Layout.secondaryTextColor)

            AdaptiveText(
                value,
                foregroundColor: Layout.secondaryTextColor,
                maxWidth: Layout.metadataValueWidth
            )
            .frame(width: Layout.metadataValueWidth, alignment: .leading)
        }
        .font(.font14)
    }

    private var tabs: some View {
        HStack(spacing: 0) {
            tabButton("歌词", isSelected: true)
            tabButton("百科", isSelected: false)
            tabButton("相似推荐", isSelected: false)
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
        )
    }

    private func tabButton(_ title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(.font14)
            .foregroundStyle(isSelected ? Layout.primaryTextColor : Layout.secondaryTextColor)
            .padding(.horizontal, 10)
            .frame(height: 25)
            .background(
                Capsule()
                    .fill(isSelected ? Color.white.opacity(0.12) : Color.clear)
            )
    }

    private var credits: some View {
        VStack(alignment: .leading, spacing: 28) {
            ForEach(creditLines, id: \.self) { line in
                Text(line)
                    .font(.font14)
                    .foregroundStyle(Layout.tertiaryTextColor)
                    .lineLimit(1)
            }
        }
    }

    private func fullPlayerBadge(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(Layout.secondaryTextColor)
            .padding(.horizontal, 4)
            .frame(height: 15)
            .overlay(
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .stroke(Layout.secondaryTextColor.opacity(0.85), lineWidth: 0.8)
            )
    }

    private var creditLines: [String] {
        [
            "作曲: 陈小霞",
            "编曲: 陈辉阳",
            "制作人: 陈小霞 / 陈辉阳",
            "录音师: 陈忠宏 / 亚祥 (HK)",
            "录音室: 白金 / AVON (HK)",
            "混音工程师: 王家栋",
            "混音录音室: 节奏"
        ]
    }

    private enum Layout {
        static let primaryTextColor = Color.textPrimaryOnDark
        static let secondaryTextColor = Color.textSecondaryOnDark
        static let tertiaryTextColor = Color.textTertiaryOnDark
        static let metadataValueWidth: CGFloat = 150
    }
}

#Preview {
    FullPlayerSongInfoView(song: .preview)
        .frame(width: 650, height: 640)
        .padding()
        .background(Color(hex: 0x151515))
}

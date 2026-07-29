//
//  SongTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct SongTable: View {
    let songs: [Song]
    let style: DataTableStyle

    init(
        songs: [Song],
        style: DataTableStyle = .plain
    ) {
        self.songs = songs
        self.style = style
    }

    var body: some View {
        DataTable(
            rows: rows,
            columns: columns,
            style: style
        )
    }

    private var rows: [SongTableRow] {
        songs.enumerated().map {
            SongTableRow(originalIndex: $0.offset, song: $0.element)
        }
    }

    private var columns: [DataTableColumn<SongTableRow>] {
        [
            DataTableColumn(
                id: "play",
                title: "",
                width: .fixed(Layout.playWidth),
                alignment: .center
            ) { row, _ in
                SongTablePlayButton(song: row.song)
            },

            DataTableColumn(
                id: "title",
                title: "标题",
                width: .flexible(min: Layout.titleMinWidth, ideal: Layout.titleIdealWidth),
                alignment: .leading,
                sort: { lhs, rhs in
                    lhs.song.name.localizedStandardCompare(rhs.song.name)
                }
            ) { row, _ in
                SongTableTitleCell(row: row)
            },

            DataTableColumn(
                id: "album",
                title: "专辑",
                width: .fixed(Layout.albumWidth),
                alignment: .leading,
                sort: { lhs, rhs in
                    lhs.song.album.name.localizedStandardCompare(rhs.song.album.name)
                }
            ) { row, _ in
                Text(row.song.album.name)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            },

            DataTableColumn(
                id: "liked",
                title: "喜欢",
                width: .fixed(Layout.likedWidth),
                alignment: .center
            ) { row, _ in
                SongTableLikeButton(isInitiallyLiked: row.isLiked)
            },

            DataTableColumn(
                id: "duration",
                title: "时长",
                width: .fixed(Layout.durationWidth),
                alignment: .trailing,
                sort: { lhs, rhs in
                    lhs.song.duration.compare(rhs.song.duration)
                }
            ) { row, _ in
                Text(row.durationText)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
                    .monospacedDigit()
                    .lineLimit(1)
            }
        ]
    }

    private enum Layout {
        static let playWidth: CGFloat = 54
        static let titleMinWidth: CGFloat = 360
        static let titleIdealWidth: CGFloat = 560
        static let albumWidth: CGFloat = 360
        static let likedWidth: CGFloat = 90
        static let durationWidth: CGFloat = 74
    }
}

private struct SongTableRow: Identifiable {
    let originalIndex: Int
    let song: Song

    var id: Int { song.id }

    var durationText: String {
        let seconds = max(song.duration / 1000, 0)
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    var titleSuffix: String? {
        let suffixes = (song.tns ?? []) + song.aliases
        guard !suffixes.isEmpty else { return nil }
        return "(\(suffixes.joined(separator: " / ")))"
    }

    var isLiked: Bool {
        false
    }
}

private struct SongTablePlayButton: View {
    let song: Song

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        Button {
            playerStore.send(.playSong(song))
        } label: {
            Image(systemName: "play.fill")
                .font(.font12.weight(.semibold))
                .foregroundStyle(Color.accentPrimary)
                .frame(width: Layout.buttonSize, height: Layout.buttonSize)
                .background(
                    Circle()
                        .fill(Color.accentPrimary.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
        .help("播放")
        .pointerStyle(.link)
    }

    private enum Layout {
        static let buttonSize: CGFloat = 28
    }
}

private struct SongTableTitleCell: View {
    let row: SongTableRow

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            RemoteImage(url: URL(string: row.song.album.picUrl))
                .frame(width: Layout.coverSize, height: Layout.coverSize)
                .rounded(radius: Layout.coverCornerRadius)

            VStack(alignment: .leading, spacing: Layout.metadataTopSpacing) {
                HStack(spacing: Layout.titleSpacing) {
                    Text(row.song.name)
                        .font(.font14.weight(.medium))
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(1)

                    if let suffix = row.titleSuffix {
                        Text(suffix)
                            .font(.font14)
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                    }
                }

                metadata
            }
        }
    }

    private var metadata: some View {
        HStack(spacing: Layout.badgeSpacing) {
            SongBadges.hq

            if let qualityBadgeKind = row.song.qualityBadgeKind {
                SongBadges.quality(qualityBadgeKind)
            }

            if row.song.requiresVIP {
                SongBadges.vip
            }

            if row.song.hasMV {
                SongBadges.mv
            }

            if let artistName = row.song.artistName {
                Text(artistName)
                    .font(.font12)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private enum Layout {
        static let coverSize: CGFloat = 42
        static let coverCornerRadius: CGFloat = 4
        static let contentSpacing: CGFloat = 12
        static let titleSpacing: CGFloat = 6
        static let metadataTopSpacing: CGFloat = 5
        static let badgeSpacing: CGFloat = 4
    }
}

private struct SongTableLikeButton: View {
    @State private var isLiked: Bool

    init(isInitiallyLiked: Bool) {
        self._isLiked = State(initialValue: isInitiallyLiked)
    }

    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.font20)
                .foregroundStyle(isLiked ? Color.accentPrimary : Color.textSecondary)
                .frame(width: Layout.actionHitSize, height: Layout.actionHitSize)
        }
        .buttonStyle(.plain)
        .help(isLiked ? "取消喜欢" : "喜欢")
        .pointerStyle(.link)
    }

    private enum Layout {
        static let actionHitSize: CGFloat = 32
    }
}

#Preview {
    SongTable(songs: Array.songsPreview)
        .environmentObject(PlayerStore())
        .padding(40)
        .frame(width: 1300)
}

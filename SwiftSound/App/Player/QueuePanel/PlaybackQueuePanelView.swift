//
//  PlaybackQueuePanelView.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/10.
//

import SwiftUI

struct PlaybackQueueOverlayView: View {
    let songs: [Song]
    let currentIndex: Int?
    let onDismiss: () -> Void
    let onPlay: (Int) -> Void
    let onRemove: (Song.ID) -> Void
    let onClear: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            PlaybackQueuePanelView(
                songs: songs,
                currentIndex: currentIndex,
                onPlay: onPlay,
                onRemove: onRemove,
                onClear: onClear
            )
            .contentShape(Rectangle())
            .onTapGesture {}
            .padding(.top, Layout.queuePanelTopInset)
            .padding(.trailing, Layout.queuePanelTrailingInset)
            .padding(.bottom, Layout.queuePanelBottomInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    @ViewBuilder
    var body1: some View {
        if currentIndex == 1 {
            Text("A") // 类型擦除
        } else {
            Image("B")
        }
    }
    
    var body2: any View {
        if currentIndex == 1 {
            Text("A") // 类型擦除
        } else {
            Image("B")
        }
    }
}

struct PlaybackQueuePanelView: View {
    let songs: [Song]
    let currentIndex: Int?
    let onPlay: (Int) -> Void
    let onRemove: (Song.ID) -> Void
    let onClear: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if songs.isEmpty {
                emptyState
            } else {
                songList
            }
        }
        .frame(width: Layout.width)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.16), radius: 18, x: 0, y: 8)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("播放列表")
                    .font(.font24)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                Text("\(songs.count)")
                    .font(.font13)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer(minLength: 20)

            Button {} label: {
                Label("收藏全部", systemImage: "plus.square")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(QueuePanelHeaderButtonStyle())
            .disabled(songs.isEmpty)

            Button(action: onClear) {
                Label("清空", systemImage: "trash")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(QueuePanelHeaderButtonStyle())
            .disabled(songs.isEmpty)
        }
        .padding(.top, Layout.headerTopInset)
        .padding(.horizontal, Layout.horizontalInset)
        .padding(.bottom, Layout.headerBottomInset)
    }

    private var songList: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 0) {
                ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                    PlaybackQueueRowView(
                        song: song,
                        isCurrent: index == currentIndex,
                        onPlay: {
                            onPlay(index)
                        },
                        onRemove: {
                            onRemove(song.id)
                        }
                    )
                }
            }
            .padding(.bottom, Layout.listBottomInset)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "music.note.list")
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(Color.textSecondary.opacity(0.45))

            Text("暂无播放内容")
                .font(.font16)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 260)
    }
}

private struct PlaybackQueueRowView: View {
    let song: Song
    let isCurrent: Bool
    let onPlay: () -> Void
    let onRemove: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: onPlay) {
            HStack(spacing: Layout.contentSpacing) {
                artwork

                VStack(alignment: .leading, spacing: 5) {
                    titleLine
                    metadataLine
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()

                Text(durationText)
                    .font(.font16)
                    .foregroundStyle(Color.textSecondary.opacity(0.75))
                    .frame(width: Layout.durationWidth, alignment: .trailing)
            }
            .padding(.horizontal, Layout.horizontalInset)
            .frame(height: Layout.height)
            .background(rowBackground)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
        .overlay(alignment: .trailing) {
            if isHovering {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.font12)
                        .foregroundStyle(Color.textSecondary)
                        .frame(width: Layout.removeButtonSize, height: Layout.removeButtonSize)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .pointerStyle(.link)
                .padding(.trailing, Layout.removeButtonTrailingInset)
            }
        }
        .onHover { isHovering = $0 }
    }

    private var artwork: some View {
        ZStack {
            RemoteImage(url: URL(string: song.album.picUrl))
                .frame(width: Layout.artworkSize, height: Layout.artworkSize)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

            if isCurrent {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.black.opacity(0.22))

                Image(systemName: "play.fill")
                    .font(.font16)
                    .foregroundStyle(Color.white)
            }
        }
        .frame(width: Layout.artworkSize, height: Layout.artworkSize)
    }

    private var titleLine: some View {
        Text(song.name)
            .font(.font18)
            .foregroundStyle(isCurrent ? Color.accentPrimary : Color.textPrimary)
            .lineLimit(1)
            .truncationMode(.tail)
    }

    private var metadataLine: some View {
        HStack(spacing: 4) {
            if song.requiresVIP {
                SongBadges.vip
            }

            if song.hasMV {
                SongBadges.mv
            }

            if song.isHiRes {
                SongBadges.hiRes
            }

            Text(song.artistName ?? "未知歌手")
                .font(.font14)
                .foregroundStyle(isCurrent ? Color.accentPrimary : Color.textSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    private var rowBackground: Color {
        if isHovering {
            return Color.surfacePrimary
        }

        return Color.clear
    }

    private var durationText: String {
        Int(song.durationTimeInterval.rounded()).minuteSecondText
    }
}

private struct QueuePanelHeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.font14)
            .foregroundStyle(Color.textSecondary)
            .opacity(configuration.isPressed ? 0.65 : 1)
            .padding(.leading, 18)
            .contentShape(Rectangle())
    }
}

private extension PlaybackQueueOverlayView {
    enum Layout {
        static let queuePanelTopInset: CGFloat = 88
        static let queuePanelTrailingInset: CGFloat = 24
        static let queuePanelBottomInset: CGFloat = 104
    }
}

private extension PlaybackQueuePanelView {
    enum Layout {
        static let width: CGFloat = 470
        static let cornerRadius: CGFloat = 8
        static let horizontalInset: CGFloat = 24
        static let headerTopInset: CGFloat = 28
        static let headerBottomInset: CGFloat = 22
        static let listBottomInset: CGFloat = 18
    }
}

private extension PlaybackQueueRowView {
    enum Layout {
        static let height: CGFloat = 78
        static let horizontalInset: CGFloat = 24
        static let contentSpacing: CGFloat = 13
        static let artworkSize: CGFloat = 50
        static let durationWidth: CGFloat = 48
        static let removeButtonSize: CGFloat = 24
        static let removeButtonTrailingInset: CGFloat = 8
    }
}

#Preview {
    PlaybackQueueOverlayView(
        songs: [.preview, .preview],
        currentIndex: 0,
        onDismiss: {},
        onPlay: { _ in },
        onRemove: { _ in },
        onClear: {}
    )
    .background(Color.surfaceSecondary)
}

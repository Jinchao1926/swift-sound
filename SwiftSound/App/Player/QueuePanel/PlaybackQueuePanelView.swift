//
//  PlaybackQueuePanelView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/10.
//

import SwiftUI

struct PlaybackQueuePanelView: View {
    let songs: [Song]
    let currentIndex: Int?
    let playbackState: PlaybackState
    let onPlay: (Int) -> Void
    let onTogglePlayPause: () -> Void
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
        .background(Color(hex: 0xFAFAFA))
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: Layout.cornerRadius,
                    bottomLeading: Layout.cornerRadius,
                    bottomTrailing: 0,
                    topTrailing: 0
                ),
                style: .continuous
            )
        )
        .shadow(color: Color.black.opacity(0.36), radius: 18, x: 0, y: 2)
    }

    private var header: some View {
        HStack(spacing: 0) {
            HStack(alignment: .top, spacing: 2) {
                Text("播放列表")
                    .font(.font20)
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
        .padding(.horizontal, Layout.headerHorizontalInset)
        .frame(height: Layout.headerHeight)
    }

    private var songList: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 0) {
                ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                    let isCurrent = index == currentIndex

                    PlaybackQueueRowView(
                        song: song,
                        isCurrent: isCurrent,
                        controlIcon: controlIcon(isCurrent: isCurrent),
                        onControlTap: {
                            handleControlTap(index: index, isCurrent: isCurrent)
                        },
                        onRemove: {
                            onRemove(song.id)
                        }
                    )
                }
            }
            .padding(.trailing, Layout.listTrailingInset)
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

private extension PlaybackQueuePanelView {
    func controlIcon(isCurrent: Bool) -> PlayableCoverImage.ControlIcon {
        isCurrent && playbackState.isPlaybackActive ? .pause : .play
    }

    func handleControlTap(index: Int, isCurrent: Bool) {
        if isCurrent {
            onTogglePlayPause()
        } else {
            onPlay(index)
        }
    }
}

private struct QueuePanelHeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.font13)
            .foregroundStyle(Color.textSecondary)
            .opacity(configuration.isPressed ? 0.65 : 1)
            .padding(.leading, 18)
            .contentShape(Rectangle())
    }
}

private extension PlaybackQueuePanelView {
    enum Layout {
        static let width: CGFloat = 386
        static let cornerRadius: CGFloat = 10

        static let headerHeight: CGFloat = 60
        static let headerHorizontalInset: CGFloat = 20
        static let listTrailingInset: CGFloat = 10
    }
}

#Preview {
    PlaybackQueuePanelView(
        songs: [.preview, .preview1, .preview2],
        currentIndex: 0,
        playbackState: .playing,
        onPlay: { _ in },
        onTogglePlayPause: {},
        onRemove: { _ in },
        onClear: {}
    )
    .padding()
    .background(Color.surfaceSecondary)
}

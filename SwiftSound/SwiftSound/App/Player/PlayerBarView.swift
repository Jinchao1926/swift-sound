//
//  PlayerBarView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/18.
//

import SwiftUI

struct PlayerBarView: View {
    let model: PlayerBarModel
    let callback: PlayerBarCallback
    let onActivate: (() -> Void)?

    init(
        model: PlayerBarModel,
        callback: PlayerBarCallback,
        onActivate: (() -> Void)? = nil
    ) {
        self.model = model
        self.callback = callback
        self.onActivate = onActivate
    }

    var body: some View {
        VStack(spacing: 0) {
            PlayerProgressTrack(
                currentTime: model.currentTime,
                duration: model.duration,
                onSeek: callback.onSeek
            )
            .zIndex(1)

            content
                .zIndex(2)
        }
        .background(Color.white)
        .frame(height: Layout.height + Layout.progressHeight)
    }

    private var content: some View {
        HStack(alignment: .center, spacing: 0) {
            nowPlaying
            transportControls
            playbackActions
        }
        .padding(.horizontal, Layout.horizontalInset)
        .frame(height: Layout.height)
    }

    private var nowPlaying: some View {
        HStack(alignment: .center, spacing: Layout.nowPlayingSpacing) {
            SongCoverImage(song: model.song)

            PlayerNowPlayingInfo(song: model.song)

            HStack(spacing: Layout.nowPlayingActionSpacing) {
                PlayerIconButton(systemName: "heart", badgeText: "10w+").help("喜欢")
                PlayerIconButton(systemName: "text.bubble", badgeText: "999+").help("查看评论")
            }
            .padding(.horizontal, Layout.nowPlayingActionInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            onActivate?()
        }
    }

    private var transportControls: some View {
        HStack(alignment: .center, spacing: Layout.transportSpacing) {
            PlayerIconButton(systemName: playbackModeIconName, action: callback.onCyclePlaybackMode)
                .help(playbackModeHelpText)

            PlayerIconButton(systemName: "backward.end.fill", action: callback.onPrevious)
                .help("上一首")

            PlayerPlayPauseButton(
                isPlaying: model.playbackState.isPlaybackActive,
                action: callback.onTogglePlayPause
            )

            PlayerIconButton(systemName: "forward.end.fill", action: callback.onNext)
                .help("下一首")

            PlayerIconButton(systemName: "list.bullet")
                .help("播放列表")
        }
        .frame(maxHeight: .infinity)
    }

    private var playbackActions: some View {
        HStack(alignment: .center, spacing: Layout.trailingActionSpacing) {
            SongBadges.hq.help("音质")

            PlayerIconButton(systemName: "plus.square").help("收藏到歌单")
            PlayerIconButton(systemName: "textformat").help("桌面歌词")
            PlayerVolumeControl(
                volume: model.volume,
                isMuted: model.isMuted,
                onSetVolume: callback.onSetVolume,
                onToggleMute: callback.onToggleMute
            )
            PlayerIconButton(systemName: "ellipsis").help("更多操作")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
    }

    private enum Layout {
        static let height: CGFloat = 80
        static let progressHeight: CGFloat = 6
        static let horizontalInset: CGFloat = 30

        static let nowPlayingSpacing: CGFloat = 10
        static let nowPlayingActionSpacing: CGFloat = 16
        static let nowPlayingActionInset: CGFloat = 10

        static let transportSpacing: CGFloat = 22

        static let actionsWidth: CGFloat = 230
        static let trailingActionSpacing: CGFloat = 20
    }
}

private extension PlayerBarView {
    var playbackModeIconName: String {
        switch model.playbackMode {
        case .listLoop:
            return "repeat"
        case .singleLoop:
            return "repeat.1"
        case .shuffle:
            return "shuffle"
        case .sequential:
            return "arrow.right"
        }
    }

    var playbackModeHelpText: String {
        switch model.playbackMode {
        case .listLoop:
            return "列表循环"
        case .singleLoop:
            return "单曲循环"
        case .shuffle:
            return "随机播放"
        case .sequential:
            return "顺序播放"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        PlayerBarView(model: .preview(), callback: .preview)
    }
    .frame(width: 1280, height: 300)
}

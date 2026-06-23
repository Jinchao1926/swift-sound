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

    var body: some View {
        content
            .padding(.top, Layout.progressReservedHeight)
            .background(Color.white)
            .overlay(alignment: .top) {
                PlayerProgressTrack(initialProgress: model.progress) {
                    callback.onSeek(model.duration * $0)
                }
                .offset(y: -Layout.progressOverlayLift)
            }
            .frame(height: Layout.height + Layout.progressReservedHeight)
    }

    private var content: some View {
        HStack(alignment: .center, spacing: 0) {
            nowPlaying
            transportControls
            playbackActions
        }
        .padding(.horizontal, Layout.horizontalInset)
        .frame(height: Layout.height)
        .background(Color.white)
    }

    private var nowPlaying: some View {
        HStack(alignment: .center, spacing: Layout.nowPlayingSpacing) {
            SongCoverImage(song: model.song)

            PlayerNowPlayingInfo(song: model.song)

            HStack(spacing: Layout.nowPlayingActionSpacing) {
                PlayerIconButton(systemName: "heart", badgeText: "10w+")
                PlayerIconButton(systemName: "text.bubble", badgeText: "999+")
            }
            .padding(.horizontal, Layout.nowPlayingActionInset)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var transportControls: some View {
        HStack(alignment: .center, spacing: Layout.transportSpacing) {
            PlayerIconButton(systemName: playbackModeIconName, action: callback.onCyclePlaybackMode)
            PlayerIconButton(systemName: "backward.end.fill", action: callback.onPrevious)

            Button(action: callback.onTogglePlayPause) {
                Image(systemName: playPauseIconName)
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: Layout.playButtonSize, height: Layout.playButtonSize)
                    .background(
                        Circle()
                            .fill(Color.accentPrimary)
                    )
            }
            .buttonStyle(.plain)
            .pointerStyle(.link)
            .help(playPauseHelpText)

            PlayerIconButton(systemName: "forward.end.fill", action: callback.onNext)
            PlayerIconButton(systemName: "list.bullet")
        }
    }

    private var playbackActions: some View {
        HStack(alignment: .center, spacing: Layout.trailingActionSpacing) {
            SongBadges.hq

            PlayerIconButton(systemName: "plus.square")
            PlayerIconButton(systemName: "textformat")
            PlayerIconButton(systemName: "speaker.wave.2")
            PlayerIconButton(systemName: "ellipsis")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private enum Layout {
        static let height: CGFloat = 80
        static let progressReservedHeight: CGFloat = 6
        static let progressOverlayLift: CGFloat = 100
        static let horizontalInset: CGFloat = 30

        static let nowPlayingSpacing: CGFloat = 10
        static let nowPlayingActionSpacing: CGFloat = 16
        static let nowPlayingActionInset: CGFloat = 10

        static let transportSpacing: CGFloat = 22
        static let playButtonSize: CGFloat = 40

        static let actionsWidth: CGFloat = 230
        static let trailingActionSpacing: CGFloat = 20
    }
}

private extension PlayerBarView {
    var playPauseIconName: String {
        switch model.playbackState {
        case .playing:
            return "pause.fill"
        default:
            return "play.fill"
        }
    }

    var playPauseHelpText: String {
        switch model.playbackState {
        case .playing:
            return "暂停"
        default:
            return "播放"
        }
    }

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
}

//#Preview {
//    PlayerBarView()
//        .frame(width: 1280)
//}

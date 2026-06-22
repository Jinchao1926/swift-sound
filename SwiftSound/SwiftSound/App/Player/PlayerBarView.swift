//
//  PlayerBarView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/18.
//

import SwiftUI

struct PlayerBarView: View {
    let song: Song?

    init(song: Song? = nil) {
        self.song = song
    }

    var body: some View {
        content
            .padding(.top, Layout.progressReservedHeight)
            .background(Color.white)
            .overlay(alignment: .top) {
                PlayerProgressTrack(initialProgress: Layout.initialProgress) { _ in }
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
            SongCoverImage(song: song)

            PlayerNowPlayingInfo(song: song)

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
            PlayerIconButton(systemName: "repeat")
            PlayerIconButton(systemName: "backward.end.fill")

            Button {} label: {
                Image(systemName: "play.fill")
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
            .help("播放")

            PlayerIconButton(systemName: "forward.end.fill")
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
        static let initialProgress: Double = 0.358
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

#Preview {
    PlayerBarView()
        .frame(width: 1280)
}

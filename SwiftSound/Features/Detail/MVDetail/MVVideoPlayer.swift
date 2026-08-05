//
//  MVVideoPlayer.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import AVKit
import SwiftUI

struct MVVideoPlayer: View {
    let player: AVPlayer?
    let error: Error?

    var body: some View {
        ZStack {
            if let player {
                VideoPlayer(player: player)
            } else if let error {
                playbackStateView(title: "视频加载失败", detail: error.localizedDescription)
            } else {
                playbackStateView(title: "正在准备视频", detail: nil)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(Layout.videoAspectRatio, contentMode: .fit)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: Layout.videoCornerRadius, style: .continuous))
    }

    private func playbackStateView(title: String, detail: String?) -> some View {
        VStack(spacing: Layout.stateSpacing) {
            Image(systemName: "play.rectangle")
                .font(.font24)
                .foregroundStyle(Color.white.opacity(0.72))

            Text(title)
                .font(.font14)
                .foregroundStyle(Color.white.opacity(0.86))

            if let detail {
                Text(detail)
                    .font(.font12)
                    .foregroundStyle(Color.white.opacity(0.52))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Layout.videoStatePadding)
    }
}

private extension MVVideoPlayer {
    enum Layout {
        static let videoAspectRatio: CGFloat = 16 / 9
        static let videoCornerRadius: CGFloat = 5
        static let videoStatePadding: CGFloat = 20
        static let stateSpacing: CGFloat = 10
    }
}

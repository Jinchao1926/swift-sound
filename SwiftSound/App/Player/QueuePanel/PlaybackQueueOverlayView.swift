//
//  PlaybackQueueOverlayView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/15.
//

import SwiftUI

struct PlaybackQueueOverlayView: View {
    let songs: [Song]
    let currentIndex: Int?
    let playbackState: PlaybackState
    let onDismiss: () -> Void
    let onPlay: (Int) -> Void
    let onTogglePlayPause: () -> Void
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
                playbackState: playbackState,
                onPlay: onPlay,
                onTogglePlayPause: onTogglePlayPause,
                onRemove: onRemove,
                onClear: onClear
            )
            .contentShape(Rectangle())
            .onTapGesture {}
            .padding(.top, Layout.queuePanelTopInset)
            .padding(.bottom, Layout.queuePanelBottomInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

private extension PlaybackQueueOverlayView {
    enum Layout {
        static let queuePanelTopInset: CGFloat = 53
        static let queuePanelBottomInset: CGFloat = 100
    }
}

#Preview {
    PlaybackQueueOverlayView(
        songs: [.preview, .preview1, .preview2],
        currentIndex: 0,
        playbackState: .playing,
        onDismiss: {},
        onPlay: { _ in },
        onTogglePlayPause: {},
        onRemove: { _ in },
        onClear: {}
    )
    .background(Color.surfaceSecondary)
}

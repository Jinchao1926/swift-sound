//
//  PlaylistOverlayContainerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/21.
//

import SwiftUI

struct PlaylistOverlayContainerView: View {
    let onDismiss: () -> Void

    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        PlaylistOverlayView(
            songs: playerStore.state.queue.songs,
            currentIndex: playerStore.state.queue.currentIndex,
            playbackState: playerStore.state.playbackState,
            onDismiss: onDismiss,
            onPlay: {
                playerStore.send(.playQueue(startIndex: $0))
            },
            onTogglePlayPause: {
                playerStore.send(.togglePlayPause)
            },
            onRemove: {
                playerStore.send(.removeFromQueue(songId: $0))
            },
            onClear: {
                playerStore.send(.clearQueue)
            }
        )
    }
}

#Preview {
    PlaylistOverlayContainerView(onDismiss: {})
        .environmentObject(PlayerStore())
        .background(Color.surfaceSecondary)
}

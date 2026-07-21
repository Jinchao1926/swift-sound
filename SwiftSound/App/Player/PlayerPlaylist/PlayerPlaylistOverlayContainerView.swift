//
//  PlayerPlaylistOverlayContainerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/21.
//

import SwiftUI

struct PlayerPlaylistOverlayContainerView: View {
    let onDismiss: () -> Void

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        PlayerPlaylistOverlayView(
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
            },
            onDiscoverMusic: {
                router.navigateBack(to: .featured())
                onDismiss()
            }
        )
    }
}

#Preview {
    PlayerPlaylistOverlayContainerView(onDismiss: {})
        .environmentObject(AppRouter())
        .environmentObject(PlayerStore())
        .background(Color.surfaceSecondary)
}

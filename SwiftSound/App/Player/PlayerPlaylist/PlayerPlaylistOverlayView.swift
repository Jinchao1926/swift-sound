//
//  PlayerPlaylistOverlayView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/15.
//

import SwiftUI

struct PlayerPlaylistOverlayView: View {
    let songs: [Song]
    let currentIndex: Int?
    let playbackState: PlaybackState
    let onDismiss: () -> Void
    let onPlay: (Int) -> Void
    let onTogglePlayPause: () -> Void
    let onRemove: (Song.ID) -> Void
    let onClear: () -> Void
    let onDiscoverMusic: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            PlayerPlaylistPanelView(
                songs: songs,
                currentIndex: currentIndex,
                playbackState: playbackState,
                onPlay: onPlay,
                onTogglePlayPause: onTogglePlayPause,
                onRemove: onRemove,
                onClear: onClear,
                onDiscoverMusic: onDiscoverMusic
            )
            .contentShape(Rectangle())
            .onTapGesture {}
            .padding(.top, Layout.panelTopInset)
            .padding(.bottom, panelBottomInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    private var panelBottomInset: CGFloat {
        songs.isEmpty ? Layout.emptyPanelBottomInset : Layout.panelBottomInset
    }
}

private extension PlayerPlaylistOverlayView {
    enum Layout {
        static let panelTopInset: CGFloat = 53
        static let panelBottomInset: CGFloat = 100
        static let emptyPanelBottomInset: CGFloat = 20
    }
}

#Preview {
    PlayerPlaylistOverlayView(
        songs: [.preview, .preview1, .preview2],
        currentIndex: 0,
        playbackState: .playing,
        onDismiss: {},
        onPlay: { _ in },
        onTogglePlayPause: {},
        onRemove: { _ in },
        onClear: {},
        onDiscoverMusic: {}
    )
    .background(Color.surfaceSecondary)
}

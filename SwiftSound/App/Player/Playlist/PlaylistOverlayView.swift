//
//  PlaylistOverlayView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/15.
//

import SwiftUI

struct PlaylistOverlayView: View {
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

            PlaylistPanelView(
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
            .padding(.top, Layout.panelTopInset)
            .padding(.bottom, Layout.panelBottomInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

private extension PlaylistOverlayView {
    enum Layout {
        static let panelTopInset: CGFloat = 53
        static let panelBottomInset: CGFloat = 100
    }
}

#Preview {
    PlaylistOverlayView(
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

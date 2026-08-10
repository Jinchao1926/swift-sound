//
//  PlayerBarModel+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Foundation

extension PlayerPresentationModel {
    static func preview(
        song: Song = .preview,
        playbackState: PlaybackState = .playing,
        playbackMode: PlaybackMode = .listLoop,
        currentTime: TimeInterval = 68,
        volume: Double = 0.34,
        isMuted: Bool = false
    ) -> PlayerPresentationModel {
        var state = PlayerState()
        _ = state.queue.play(song)
        state.playbackState = playbackState
        state.playbackMode = playbackMode
        state.currentTime = min(currentTime, song.durationTimeInterval)
        state.volume = volume
        state.isMuted = isMuted

        guard let model = PlayerPresentationModel(state: state) else {
            preconditionFailure("PlayerBarView preview requires a current song")
        }
        return model
    }
}

extension PlayerControlsActions {
    static let preview = PlayerControlsActions(
        onTogglePlayPause: {},
        onPrevious: {},
        onNext: {},
        onSeek: { _ in },
        onSeekAndPlay: { _ in },
        onCyclePlaybackMode: {},
        onSetVolume: { _ in },
        onToggleMute: {}
    )
}

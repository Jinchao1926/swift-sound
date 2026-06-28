//
//  PlayerPresentationModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/23.
//

import Foundation

struct PlayerPresentationModel {
    let song: Song
    let playbackState: PlaybackState
    let playbackMode: PlaybackMode
    let currentTime: TimeInterval
    let duration: TimeInterval
    let volume: Double
    let isMuted: Bool

    init?(state: PlayerState) {
        guard let song = state.currentSong else { return nil }

        self.song = song
        self.playbackState = state.playbackState
        self.playbackMode = state.playbackMode
        self.currentTime = state.currentTime
        self.duration = song.durationTimeInterval
        self.volume = state.volume
        self.isMuted = state.isMuted
    }
}

struct PlayerControlsCallback {
    let onTogglePlayPause: () -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onSeek: (TimeInterval) -> Void
    let onCyclePlaybackMode: () -> Void
    let onSetVolume: (Double) -> Void
    let onToggleMute: () -> Void
}

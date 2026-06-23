//
//  PlayerBarModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/23.
//

import Foundation

struct PlayerBarModel {
    let song: Song
    let playbackState: PlaybackState
    let playbackMode: PlaybackMode
    let currentTime: TimeInterval
    let duration: TimeInterval
    let progress: Double

    init?(state: PlayerState) {
        guard let song = state.currentSong else { return nil }

        self.song = song
        self.playbackState = state.playbackState
        self.playbackMode = state.playbackMode
        self.currentTime = state.currentTime
        self.duration = song.durationTimeInterval
        self.progress = Self.progress(currentTime: state.currentTime, duration: duration)
    }
}

private extension PlayerBarModel {
     static func progress(currentTime: TimeInterval, duration: TimeInterval) -> Double {
        guard duration > 0 else { return 0 }

        return min(max(currentTime / duration, 0), 1)
    }
}

struct PlayerBarCallback {
    let onTogglePlayPause: () -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onSeek: (TimeInterval) -> Void
    let onCyclePlaybackMode: () -> Void
}

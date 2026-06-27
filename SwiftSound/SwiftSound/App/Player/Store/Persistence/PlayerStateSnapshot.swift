//
//  PlayerStateSnapshot.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/25.
//

import Foundation

struct PlayerStateSnapshot: Codable {
    let queueSongs: [Song]
    let currentIndex: Int?
    let playbackMode: PlaybackMode
    let volume: Double
    let isMuted: Bool
    let currentTime: TimeInterval

    init(state: PlayerState) {
        self.queueSongs = state.queue.songs
        self.currentIndex = state.queue.currentIndex
        self.playbackMode = state.playbackMode
        self.volume = state.volume
        self.isMuted = state.isMuted
        self.currentTime = state.currentTime
    }

    func makePlayerState() -> PlayerState {
        var state = PlayerState()
        state.queue = PlaybackQueue(songs: queueSongs, currentIndex: currentIndex)
        state.playbackMode = playbackMode
        state.volume = min(max(volume, 0), 1)
        state.isMuted = isMuted

        if let currentSong = state.currentSong {
            state.currentTime = min(max(currentTime, 0), currentSong.durationTimeInterval)
            state.playbackState = .paused
        } else {
            state.currentTime = 0
            state.playbackState = .stopped
        }

        return state
    }
}

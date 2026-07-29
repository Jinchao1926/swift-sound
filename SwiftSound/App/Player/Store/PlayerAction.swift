//
//  PlayerAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum PlayerAction {
    // Selection
    case playSong(Song)
    case playQueuedSong(at: Int)
    case playQueue([Song], startIndex: Int)

    // Transport
    case play
    case pause
    case togglePlayPause
    case next
    case previous
    case seek(to: TimeInterval)

    // Queue
    case appendToQueue(Song)
    case appendManyToQueue([Song])
    case removeFromQueue(songId: Song.ID)
    case clearQueue

    // Mode
    case setPlaybackMode(PlaybackMode)
    case cyclePlaybackMode

    // Audio
    case setVolume(Double)
    case toggleMute
}

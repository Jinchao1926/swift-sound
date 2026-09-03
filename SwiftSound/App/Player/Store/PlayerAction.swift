//
//  PlayerAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum PlayerAction {
    // Play
    enum PlayTarget {
        /// Play one song, adding it to the queue when it is not already present.
        case song(Song)

        /// Replace the queue with songs and play the song at startIndex.
        case songs([Song], startIndex: Int)

        /// Load songs from a remote album or playlist source before playing them.
        case source(PlayableSource)

        /// Play a song at an index in the current queue.
        case queueIndex(Int)
    }

    case play(PlayTarget)

    // Transport
    case resume
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

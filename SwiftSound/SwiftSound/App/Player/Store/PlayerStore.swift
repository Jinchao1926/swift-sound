//
//  PlayerStore.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation
import Combine

/// Defines app-level playback store
class PlayerStore: ObservableObject {
    @Published private(set) var state: PlayerState
    
    init(state: PlayerState = PlayerState()) {
        self.state = state
    }
    
    func send(_ action: PlayerAction) {
        reduce(action)
    }
}

private extension PlayerStore {
    func reduce(_ action: PlayerAction) {
        switch action {
        case .currentSong(let currentSongAction):
            reduce(currentSongAction)
        case .playback(let playbackAction):
            reduce(playbackAction)
        case .queue(let queueAction):
            reduce(queueAction)
        case .mode(let playbackModeAction):
            reduce(playbackModeAction)
        }
    }

    func reduce(_ action: CurrentSongAction) {
        switch action {
        case .play(let song):
            //
        case .playQueue(let startIndex):
            //
        }
    }

    func reduce(_ action: PlaybackAction) {
        switch action {
        case .play:
            //
        case .pause:
            //
        case .toggle:
            //
        case .next:
            //
        case .previous:
            //
        case .seek(let timeInterval):
            //
        case .progressUpdated(let timeInterval):
            //
        case .setVolume(let double):
            //
        }
    }

    func reduce(_ action: QueueAction) {
        switch action {
        case .append(let song):
            //
        case .appendMany(let array):
            //
        case .remove(let songId):
            //
        case .clear:
            //
        }
    }

    func reduce(_ action: PlaybackModeAction) {
        switch action {
        case .set(let playbackMode):
            //
        case .cycle:
            //
        }
    }
}

//
//  PlayerStore.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation
import Combine

/// Defines app-level playback store
final class PlayerStore: ObservableObject {
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
            state.queue.play(song)
            state.progress = 0
            state.playbackState = .playing

        case .playQueue(let startIndex):
            guard state.queue.play(at: startIndex) != .unchanged else { return }
            state.progress = 0
            state.playbackState = .playing
        }
    }

    func reduce(_ action: PlaybackAction) {
        let prev = state

        switch action {
        case .play:
            if state.currentSong != nil {
                state.playbackState = .playing
            }

        case .pause:
            state.playbackState = .paused

        case .toggle:
            let prevState = prev.playbackState
            switch prevState {
            case .stopped:
                if state.currentSong != nil {
                    state.playbackState = .playing
                }
            case .playing:
                state.playbackState = .paused
            case .paused:
                state.playbackState = .playing
            default:
                break
            }

        case .next:
            handleQueueMoveResult(state.queue.moveNext(mode: state.playbackMode))
        case .previous:
            handleQueueMoveResult(state.queue.movePrevious(mode: state.playbackMode))
        case .seek(let timeInterval):
            state.progress = timeInterval

        case .progressUpdated(let timeInterval):
            state.progress = timeInterval

        case .setVolume(let double):
            state.volume = double
        }
    }

    func reduce(_ action: QueueAction) {
        switch action {
        case .append(let song):
            state.queue.append(song)

        case .appendMany(let array):
            state.queue.appendMany(array)

        case .remove(let songId):
            handleQueueMoveResult(state.queue.remove(songId: songId, mode: state.playbackMode))
            
        case .clear:
            state.queue.clear()
            state.progress = 0
            state.playbackState = .stopped
        }
    }

    func reduce(_ action: PlaybackModeAction) {
        let prev = state

        switch action {
        case .set(let playbackMode):
            state.playbackMode = playbackMode

        case .cycle:
            state.playbackMode = prev.playbackMode.next()
        }
    }
}

private extension PlayerStore {
    func handleQueueMoveResult(_ result: QueueMoveResult) {
        switch result {
        case .moved:
            state.progress = 0
            state.playbackState = .playing

        case .stopped:
            state.progress = 0
            state.playbackState = .stopped

        case .unchanged:
            break
        }
    }
}

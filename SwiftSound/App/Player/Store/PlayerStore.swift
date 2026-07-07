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

    private let persistence: PlayerStatePersistence
    private var playbackCoordinator: PlaybackCoordinator?

    init(
        state: PlayerState? = nil,
        persistence: PlayerStatePersistence = FilePlayerStatePersistence()
    ) {
        self.persistence = persistence
        let initialState = state ?? persistence.load() ?? PlayerState()
        self.state = initialState
        self.playbackCoordinator = PlaybackCoordinator(
            initialVolume: initialState.effectiveVolume,
            stateProvider: { [weak self] in
                self?.state
            },
            sendEvent: { [weak self] event in
                self?.handle(event)
            }
        )
    }

    func send(_ action: PlayerAction) {
        reduce(action)
        playbackCoordinator?.handle(action: action, state: state)
        persist(after: action)
    }

    func flushPersistence() {
        persistNow()
    }
}

// MARK: - Reducer
private extension PlayerStore {
    func reduce(_ action: PlayerAction) {
        if reduceSelectionAction(action) { return }
        if reducePlaybackStateAction(action) { return }
        if reducePlaybackNavigationAction(action) { return }
        if reducePlaybackTimeAction(action) { return }
        if reduceQueueAction(action) { return }
        if reduceModeAction(action) { return }
        reduceAudioAction(action)
    }

    @discardableResult
    func reduceSelectionAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .playSong(let song):
            handleQueueTransition(state.queue.play(song))
            return true

        case .playQueue(let startIndex):
            handleQueueTransition(state.queue.play(at: startIndex))
            return true

        default:
            return false
        }
    }

    @discardableResult
    func reducePlaybackStateAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .play:
            if state.currentSong != nil {
                state.playbackState = .playing
            }
            return true

        case .pause:
            state.playbackState = .paused
            return true

        case .togglePlayPause:
            togglePlayPause()
            return true

        default:
            return false
        }
    }

    @discardableResult
    func reducePlaybackNavigationAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .next:
            handleQueueTransition(state.queue.moveNext(mode: state.playbackMode))
            return true

        case .previous:
            handleQueueTransition(state.queue.movePrevious(mode: state.playbackMode))
            return true

        default:
            return false
        }
    }

    @discardableResult
    func reducePlaybackTimeAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .seek(let timeInterval):
            state.currentTime = timeInterval
            return true

        default:
            return false
        }
    }

    @discardableResult
    func reduceQueueAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .appendToQueue(let song):
            state.queue.append(song)
            return true

        case .appendManyToQueue(let array):
            state.queue.appendMany(array)
            return true

        case .removeFromQueue(let songId):
            let transition = state.queue.remove(songId: songId, mode: state.playbackMode)
            handleQueueTransition(transition)
            return true

        case .clearQueue:
            state.queue.clear()
            state.currentTime = 0
            state.playbackState = .stopped
            return true

        default:
            return false
        }
    }

    @discardableResult
    func reduceModeAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .setPlaybackMode(let playbackMode):
            state.playbackMode = playbackMode
            return true

        case .cyclePlaybackMode:
            state.playbackMode = state.playbackMode.next()
            return true

        default:
            return false
        }
    }

    func reduceAudioAction(_ action: PlayerAction) {
        switch action {
        case .setVolume(let volume):
            let clampedVolume = volume.clamped(to: 0...1)
            state.volume = clampedVolume
            state.isMuted = clampedVolume == 0

        case .toggleMute:
            state.isMuted.toggle()

        default:
            break
        }
    }
}

// MARK: - Private
private extension PlayerStore {
    func handle(_ event: PlaybackEvent) {
        switch event {
        case .loading(let songId):
            guard songId == state.currentSong?.id else { return }
            state.playbackState = .loading

        case .started(let songId):
            guard songId == state.currentSong?.id else { return }
            state.playbackState = .playing

        case .failed(let songId, let message):
            guard songId == state.currentSong?.id else { return }
            state.playbackState = .failed(message)
            playbackCoordinator?.handle(event: event, state: state)
            persistNow()

        case .finished(let songId):
            guard songId == state.currentSong?.id else { return }
            // 自动下一首歌
            handleQueueTransition(state.queue.moveNext(mode: state.playbackMode))
            playbackCoordinator?.handle(event: event, state: state)
            persistNow()

        case .timeUpdated(let songId, let timeInterval):
            guard songId == state.currentSong?.id else { return }
            let duration = state.currentSong?.durationTimeInterval ?? timeInterval
            state.currentTime = timeInterval.clamped(to: 0...duration)
        }
    }

    func persist(after action: PlayerAction) {
        switch action {
        case .play:
            return

        case .togglePlayPause where state.playbackState != .paused:
            return

        default:
            persistNow()
        }
    }

    func persistNow() {
        persistence.save(state)
    }

    func togglePlayPause() {
        switch state.playbackState {
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
    }

    func handleQueueTransition(_ transition: QueueTransition) {
        switch transition {
        case .play, .replay:
            state.currentTime = 0
            state.playbackState = .playing

        case .stop:
            state.currentTime = 0
            state.playbackState = .stopped

        case .noChange:
            break
        }
    }
}

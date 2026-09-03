//
//  PlayerStore.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation
import Combine

enum PlayerStoreEvent: Equatable {
    case playlistAddition(id: UUID)

    var id: UUID {
        switch self {
        case .playlistAddition(let id):
            return id
        }
    }
}

private enum PlayerEffectEvent {
    case sourceLoaded(requestID: UUID, source: PlayableSource, songs: [Song])
    case sourceLoadFailed(requestID: UUID)
}

/// Defines app-level playback store
final class PlayerStore: ObservableObject {
    // MARK: - State
    @Published private(set) var state: PlayerState

    // MARK: - Dependencies
    private let persistence: PlayerStatePersistence
    private let playableSongsProvider: PlayableSongsProviding
    private var playbackCoordinator: PlaybackCoordinator?

    // MARK: - Source Loading
    private var sourceLoadingTask: Task<Void, Never>?
    private var activeSourceRequestID: UUID?

    // MARK: - Events
    private let eventSubject = PassthroughSubject<PlayerStoreEvent, Never>()

    // MARK: - Lifecycle
    init(
        state: PlayerState? = nil,
        persistence: PlayerStatePersistence = FilePlayerStatePersistence(),
        playableSongsProvider: PlayableSongsProviding = PlayableSongsProvider()
    ) {
        self.persistence = persistence
        self.playableSongsProvider = playableSongsProvider
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

    // MARK: - Public API
    var events: AnyPublisher<PlayerStoreEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    func send(_ action: PlayerAction) {
        if case .play(.source(let source)) = action {
            load(source: source)
            return
        }

        reduce(action)
        playbackCoordinator?.handle(action: action, state: state)
        persist(after: action)
    }

    func flushPersistence() {
        persistNow()
    }

    // MARK: - Event Publishing
    private func emit(_ event: PlayerStoreEvent) {
        eventSubject.send(event)
    }
}

// MARK: - Source Loading
private extension PlayerStore {
    func load(source: PlayableSource) {
        // A newer request supersedes the previous source load.
        let requestID = UUID()
        activeSourceRequestID = requestID
        sourceLoadingTask?.cancel()

        sourceLoadingTask = Task { [weak self, playableSongsProvider] in
            do {
                let songs = try await playableSongsProvider.fetchSongs(for: source)
                guard !Task.isCancelled else { return }
                self?.receive(.sourceLoaded(requestID: requestID, source: source, songs: songs))
            } catch {
                guard !Task.isCancelled else { return }
                self?.receive(.sourceLoadFailed(requestID: requestID))
            }
        }
    }

    func receive(_ event: PlayerEffectEvent) {
        switch event {
        case .sourceLoaded(let requestID, let source, let songs):
            // Ignore responses from cancelled or superseded requests.
            guard requestID == activeSourceRequestID, !songs.isEmpty else { return }
            state.songIDsBySource[source] = Set(songs.map(\.id))

            let startIndex = state.currentSong.flatMap { currentSong in
                songs.firstIndex { $0.id == currentSong.id }
            } ?? 0
            send(.play(.songs(songs, startIndex: startIndex)))

        case .sourceLoadFailed(let requestID):
            guard requestID == activeSourceRequestID else { return }
        }
    }
}

// MARK: - Action Reduction
private extension PlayerStore {
    // MARK: Action Routing
    func reduce(_ action: PlayerAction) {
        if reducePlayAction(action) { return }
        if reducePlaybackStateAction(action) { return }
        if reducePlaybackNavigationAction(action) { return }
        if reducePlaybackTimeAction(action) { return }
        if reduceQueueAction(action) { return }
        if reduceModeAction(action) { return }
        reduceAudioAction(action)
    }

    // MARK: Play
    @discardableResult
    func reducePlayAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .play(.song(let song)):
            let previousQueueSongIDs = queueSongIDs()
            handleQueueTransition(state.queue.play(song))
            emitPlaylistAdditionIfNeeded(before: previousQueueSongIDs)
            return true

        case .play(.songs(let songs, let startIndex)):
            guard songs[safe: startIndex] != nil else { return true }
            let previousQueueSongIDs = queueSongIDs()
            handleQueueTransition(state.queue.replace(with: songs, startIndex: startIndex))
            emitPlaylistAdditionIfNeeded(before: previousQueueSongIDs)
            return true

        case .play(.source):
            return true

        case .play(.queueIndex(let queueIndex)):
            handleQueueTransition(state.queue.play(at: queueIndex))
            return true

        default:
            return false
        }
    }

    // MARK: Transport
    @discardableResult
    func reducePlaybackStateAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .resume:
            if state.currentSong != nil {
                state.playbackState = .playing
            }
            return true

        case .pause:
            state.playbackState = .paused
            return true

        case .togglePlayPause:
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
            return true

        default:
            return false
        }
    }

    // MARK: Navigation
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

    // MARK: Time
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

    // MARK: Queue
    @discardableResult
    func reduceQueueAction(_ action: PlayerAction) -> Bool {
        switch action {
        case .appendToQueue(let song):
            let previousQueueSongIDs = queueSongIDs()
            if state.queue.append(song) {
                emitPlaylistAdditionIfNeeded(before: previousQueueSongIDs)
            }
            return true

        case .appendManyToQueue(let array):
            let previousQueueSongIDs = queueSongIDs()
            if state.queue.appendMany(array) {
                emitPlaylistAdditionIfNeeded(before: previousQueueSongIDs)
            }
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

    // MARK: Mode
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

    // MARK: Audio
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

// MARK: - Playback Events
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
            // Automatic navigation also uses the same transition semantics.
            handleQueueTransition(state.queue.moveNext(mode: state.playbackMode))
            playbackCoordinator?.handle(event: event, state: state)
            persistNow()

        case .timeUpdated(let songId, let timeInterval):
            guard songId == state.currentSong?.id else { return }
            let duration = state.currentSong?.durationTimeInterval ?? timeInterval
            state.currentTime = timeInterval.clamped(to: 0...duration)
        }
    }
}

// MARK: - Persistence
private extension PlayerStore {
    func persist(after action: PlayerAction) {
        switch action {
        case .resume:
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
}

// MARK: - Queue Transitions
private extension PlayerStore {
    func handleQueueTransition(_ transition: QueueTransition) {
        switch transition {
        case .play:
            // A new song always starts from the beginning.
            state.currentTime = 0
            state.playbackState = .playing

        case .replay:
            // Replay means the same song was selected; keep its current time.
            state.playbackState = .playing

        case .stop:
            state.currentTime = 0
            state.playbackState = .stopped

        case .noChange:
            break
        }
    }
}

// MARK: - Helpers
private extension PlayerStore {
    func queueSongIDs() -> [Song.ID] { state.queue.songs.map(\.id) }

    func emitPlaylistAdditionIfNeeded(before previousQueueSongIDs: [Song.ID]) {
        guard previousQueueSongIDs != queueSongIDs() else { return }
        emit(.playlistAddition(id: UUID()))
    }
}

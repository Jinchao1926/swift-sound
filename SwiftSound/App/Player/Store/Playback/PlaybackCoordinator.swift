//
//  PlaybackCoordinator.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Combine
import Foundation

final class PlaybackCoordinator {
    private let songsRespository: SongsRespository
    private let audioController: AudioPlaybackControlling
    private let stateProvider: () -> PlayerState?
    private let sendEvent: (PlaybackEvent) -> Void

    private var cancellables = Set<AnyCancellable>()
    private var playbackTask: Task<Void, Never>?

    init(
        songsRespository: SongsRespository = SongsRespository(),
        audioController: AudioPlaybackControlling = AVPlayerAudioController(),
        initialVolume: Double = 1,
        stateProvider: @escaping () -> PlayerState?,
        sendEvent: @escaping (PlaybackEvent) -> Void
    ) {
        self.songsRespository = songsRespository
        self.audioController = audioController
        self.stateProvider = stateProvider
        self.sendEvent = sendEvent
        self.audioController.setVolume(initialVolume)
        observeAudioEvents()
    }

    func handle(action: PlayerAction, state: PlayerState) {
        switch action {
        case .playSong, .playQueuedSong, .playQueue, .next, .previous:
            syncCurrentTrack(with: state)

        case .play, .pause, .togglePlayPause:
            syncTransport(with: state)

        case .seek(let timeInterval):
            audioController.seek(to: timeInterval)

        case .clearQueue:
            stopPlayback()

        case .removeFromQueue:
            syncAfterQueueMutation(with: state)

        case .setVolume, .toggleMute:
            audioController.setVolume(state.effectiveVolume)

        case .appendToQueue, .appendManyToQueue, .setPlaybackMode, .cyclePlaybackMode:
            break
        }
    }

    func handle(event: PlaybackEvent, state: PlayerState) {
        switch event {
        case .finished:
            syncCurrentTrack(with: state)

        case .failed:
            audioController.pause()

        case .loading, .started, .timeUpdated:
            break
        }
    }
}

// MARK: - Observe
private extension PlaybackCoordinator {
    func observeAudioEvents() {
        audioController.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleAudioEvent(event)
            }
            .store(in: &cancellables)
    }

    func handleAudioEvent(_ event: AudioPlaybackEvent) {
        switch event.kind {
        case .timeUpdated(let timeInterval):
            sendEvent(.timeUpdated(songId: event.songId, time: timeInterval))

        case .finished:
            sendEvent(.finished(songId: event.songId))

        case .failed(let message):
            sendEvent(.failed(songId: event.songId, message: message))
        }
    }
}

// MARK: - Private
private extension PlaybackCoordinator {
    func syncCurrentTrack(with state: PlayerState) {
        guard state.playbackState == .playing || state.playbackState == .loading else {
            stopPlayback()
            return
        }

        loadCurrentSong(with: state)
    }

    func syncTransport(with state: PlayerState) {
        switch state.playbackState {
        case .playing:
            resumeOrLoadCurrentSong(with: state)

        case .paused:
            audioController.pause()

        default:
            break
        }
    }

    func syncAfterQueueMutation(with state: PlayerState) {
        if state.playbackState == .playing || state.playbackState == .loading {
            syncCurrentTrack(with: state)
        } else if state.currentSong == nil {
            stopPlayback()
        }
    }

    func resumeOrLoadCurrentSong(with state: PlayerState) {
        guard let song = state.currentSong else { return }

        if audioController.isLoaded(songId: song.id) {
            audioController.play()
        } else {
            loadCurrentSong(with: state)
        }
    }
}

// MARK: - Loading Resource
private extension PlaybackCoordinator {
    func stopPlayback() {
        playbackTask?.cancel()
        audioController.stop()
    }

    func loadCurrentSong(with state: PlayerState) {
        playbackTask?.cancel()

        guard let song = state.currentSong else {
            audioController.stop()
            return
        }

        let songId = song.id
        let startTime = state.currentTime
        sendEvent(.loading(songId: songId))

        playbackTask = Task { [weak self] in
            guard let self else { return }

            do {
                guard let url = try await songsRespository.fetchSongPlaybackURL(songId) else {
                    await MainActor.run {
                        self.sendEvent(.failed(songId: songId, message: "暂时无法获取播放地址"))
                    }
                    return
                }

                await MainActor.run {
                    guard self.stateProvider()?.currentSong?.id == songId else { return }
                    self.audioController.load(url: url, songId: songId, autoPlay: true, startTime: startTime)
                    self.sendEvent(.started(songId: songId))
                }
            } catch is CancellationError {
                return
            } catch {
                await MainActor.run {
                    self.sendEvent(.failed(songId: songId, message: error.localizedDescription))
                }
            }
        }
    }
}

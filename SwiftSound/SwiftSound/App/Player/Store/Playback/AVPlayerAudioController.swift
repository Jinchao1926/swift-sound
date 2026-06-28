//
//  AVPlayerAudioController.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Foundation
import AVFoundation
import Combine

final class AVPlayerAudioController: AudioPlaybackControlling {
    let events = PassthroughSubject<AudioPlaybackEvent, Never>()

    private let player = AVPlayer()
    private var currentSongId: Song.ID?
    private var timeObserver: Any?
    private var itemObservers: [NSObjectProtocol] = []

    deinit {
        removeTimeObserver()
        removeItemObservers()
    }

    // MARK: - AudioPlaybackControlling
    func load(url: URL, songId: Song.ID, autoPlay: Bool, startTime: TimeInterval = 0) {
        currentSongId = songId

        let item = AVPlayerItem(url: url)
        replaceCurrentItem(with: item)
        player.seek(to: cmTime(startTime), toleranceBefore: .zero, toleranceAfter: .zero)
        observe(item, songId: songId)
        addTimeObserverIfNeeded()

        if autoPlay {
            player.play()
        }
    }

    func isLoaded(songId: Song.ID) -> Bool {
        currentSongId == songId && player.currentItem != nil
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func stop() {
        currentSongId = nil
        player.pause()
        replaceCurrentItem(with: nil)
    }

    func seek(to time: TimeInterval) {
        player.seek(to: cmTime(time), toleranceBefore: .zero, toleranceAfter: .zero)
    }

    func setVolume(_ volume: Double) {
        player.volume = Float(volume.clamped(to: 0...1))
    }
}

// MARK: - Private
private extension AVPlayerAudioController {
    func replaceCurrentItem(with item: AVPlayerItem?) {
        removeItemObservers()
        player.replaceCurrentItem(with: item)
    }

    func addTimeObserverIfNeeded() {
        guard timeObserver == nil else { return }

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self, let currentSongId else { return }
            send(.timeUpdated(time.seconds), songId: currentSongId)
        }
    }

    func observe(_ item: AVPlayerItem, songId: Song.ID) {
        let endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.send(.finished, songId: songId)
        }

        let failedObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] notification in
            let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
            let message = error?.localizedDescription ?? "播放失败"
            self?.send(.failed(message), songId: songId)
        }

        itemObservers = [endObserver, failedObserver]
    }

    func removeTimeObserver() {
        guard let timeObserver else { return }
        player.removeTimeObserver(timeObserver)
        self.timeObserver = nil
    }

    func removeItemObservers() {
        itemObservers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        itemObservers.removeAll()
    }

    func send(_ kind: AudioPlaybackEvent.Kind, songId: Song.ID?) {
        events.send(AudioPlaybackEvent(songId: songId, kind: kind))
    }

    func cmTime(_ time: TimeInterval) -> CMTime {
        CMTime(seconds: max(time, 0), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
}

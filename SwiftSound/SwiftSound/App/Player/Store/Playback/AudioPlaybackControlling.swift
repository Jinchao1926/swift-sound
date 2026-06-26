//
//  AudioPlaybackControlling.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Foundation
import Combine

struct AudioPlaybackEvent {
    enum Kind {
        case timeUpdated(TimeInterval)
        case finished
        case failed(String)
    }

    let songId: Song.ID?
    let kind: Kind
}

protocol AudioPlaybackControlling: AnyObject {
    var events: PassthroughSubject<AudioPlaybackEvent, Never> { get }

    func load(url: URL, songId: Song.ID, autoPlay: Bool, startTime: TimeInterval)
    func isLoaded(songId: Song.ID) -> Bool

    func play()
    func pause()
    func stop()

    func seek(to time: TimeInterval)
    func setVolume(_ volume: Double)
}

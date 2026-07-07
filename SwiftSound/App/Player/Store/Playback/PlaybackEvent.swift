//
//  PlaybackEvent.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Foundation

enum PlaybackEvent {
    case loading(songId: Song.ID)
    case started(songId: Song.ID)
    case failed(songId: Song.ID?, message: String)
    case finished(songId: Song.ID?)
    case timeUpdated(songId: Song.ID?, time: TimeInterval)
}

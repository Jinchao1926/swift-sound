//
//  PlayerAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum PlayerAction {
    case currentSong(CurrentSongAction)
    case playback(PlaybackAction)
    case queue(QueueAction)
    case mode(PlaybackModeAction)
}

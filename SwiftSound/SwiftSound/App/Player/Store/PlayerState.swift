//
//  PlayerState.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum PlaybackState {
    case stopped
    case loading
    case playing
    case paused
    case failed(String)
}

enum PlaybackMode: CaseIterable {
    case listLoop      // 列表循环
    case singleLoop    // 单曲循环
    case shuffle       // 随机播放
    case sequential    // 顺序播放，播完停止
    
    func next() -> Self {
        let allCases = Self.allCases

        guard let currentIndex = allCases.firstIndex(of: self) else {
            return .listLoop
        }
        let nextIndex = (currentIndex + 1) % allCases.count
        return allCases[nextIndex]
    }
}

struct PlayerState {
    // song states
    var queue: [Song] = []
    var currentIndex: Int?
    var progress: TimeInterval = 0

    // playback states
    var playbackState: PlaybackState = .stopped
    var playbackMode: PlaybackMode = .listLoop
    var volume: Double = 1
    
    var currentSong: Song? {
        queue[safe: currentIndex]
    }
}

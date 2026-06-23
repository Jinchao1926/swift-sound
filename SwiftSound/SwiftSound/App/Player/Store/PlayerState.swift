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
    /// 列表循环
    case listLoop
    /// 单曲循环
    case singleLoop
    /// 随机播放
    case shuffle
    /// 顺序播放，播完停止
    case sequential

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
    var queue: PlaybackQueue = PlaybackQueue()

    // playback states
    var playbackState: PlaybackState = .stopped
    var playbackMode: PlaybackMode = .listLoop
    var volume: Double = 1

    var currentSong: Song? { queue.currentSong }
    var currentIndex: Int? { queue.currentIndex }
    var currentTime: TimeInterval = 0
    var currentProgress: Double {
        guard let duration = currentSong?.duration else { return 0 }
        return currentTime / Double(duration)
    }
}

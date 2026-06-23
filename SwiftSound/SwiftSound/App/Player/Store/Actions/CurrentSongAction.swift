//
//  CurrentSongAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum CurrentSongAction {

    /**
     * 播放某一首歌
     *
     - 如果这首歌已在 state.queue，切到对应 index
     - 如果不在 state.queue，追加到队列末尾，并切到它
     - 如果和当前歌曲不同，重置 progress = 0
     - 设置 playbackState = .playing
     */
    case play(Song)
    /**
     * 从当前播放队列里的某个 startIndex 开始播放
     *
     - 它不改变 queue 内容，只改变当前播放位置
     */
    case playQueue(startIndex: Int)
}

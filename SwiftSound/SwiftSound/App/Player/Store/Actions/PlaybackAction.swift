//
//  PlaybackAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum PlaybackAction {
    case play
    case pause
    /**
     * 切换播放/暂停
     *
     - .playing -> .paused
     - .paused -> .playing
     - .stopped 且有 currentSong -> .playing
     */
    case toggle
    /**
     * 播放下一首。
     *
     语义由 PlaybackMode 决定：

     - listLoop: 到末尾后回到第一首
     - sequential: 到末尾后停止
     - singleLoop: 可以保持当前 index，重新播放当前歌
     - shuffle: 随机选下一首
     */
    case next
    /**
     * 播放上一首。
     *
     语义由 PlaybackMode 决定：

     - listLoop: 到首部后回到最后一首
     - sequential: 到首部后停止
     - singleLoop: 可以保持当前 index，重新播放当前歌
     - shuffle: 随机选下一首
     */
    case previous
    /**
     * 用户主动拖动进度条
     */
    case seek(TimeInterval)
    /**
     * 播放引擎上报当前进度。
     
     这个和 seek 不一样：
     - seek 是用户命令
     - progressUpdated 是播放器回调
     */
    case progressUpdated(TimeInterval)
    /**
     * 修改音量
     */
    case setVolume(Double)
}

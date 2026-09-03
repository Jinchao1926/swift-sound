//
//  SettingSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/3.
//

import Foundation

enum SettingSection: String, CaseIterable, Identifiable {
    case account = "账号"
    case general = "常规"
    case playback = "播放"
    case privacy = "消息与隐私"
    case shortcut = "快捷键"
    case download = "品质与下载"
    case lyric = "桌面歌词"
    case about = "关于"

    var id: String { self.rawValue }
}

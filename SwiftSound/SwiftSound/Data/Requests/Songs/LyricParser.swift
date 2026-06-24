//
//  LyricParser.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Foundation

enum LyricParser {
    private static let timeRegex = /^\[(\d{2}):(\d{2})\.(\d{2,3})\]\s*(.*?)$/

    /// 解析 LRC 歌词文本为按时间排序的歌词行
    static func parse(_ lyricText: String?) -> [LyricLine] {
        guard let lyricText, !lyricText.isEmpty else {
            return []
        }

        let lines = lyricText.split(separator: "\n", omittingEmptySubsequences: false)
        let lyricLines = lines.compactMap { parseLine(String($0)) }

        return lyricLines.sorted { $0.time < $1.time }
    }

    private static func parseLine(_ line: String) -> LyricLine? {
        guard !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        guard let match = line.firstMatch(of: timeRegex),
              let minutes = Int(match.output.1),
              let seconds = Int(match.output.2) else {
            return nil
        }

        let millisecondText = String(match.output.3)
        guard var milliseconds = Int(millisecondText) else {
            return nil
        }

        if millisecondText.count == 2 {
            milliseconds *= 10
        }

        let text = String(match.output.4)
        let time = minutes * 60 * 1000 + seconds * 1000 + milliseconds

        return LyricLine(time: TimeInterval(time), text: text)
    }
}

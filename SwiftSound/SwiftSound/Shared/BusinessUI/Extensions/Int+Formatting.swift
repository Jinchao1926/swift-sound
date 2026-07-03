//
//  Int+Formatting.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

extension Int {
    var playCountText: String {
        guard self >= 10_000 else {
            return "\(self)"
        }

        let rawValue = Double(self) / 10_000
        let rounded = (rawValue * 10).rounded() / 10    // 小数

        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(rounded))万"
        } else {
            return String(format: "%.1f万", rounded)
        }
    }

    /// Seconds as `m:ss` text.
    var minuteSecondText: String {
        let minutes = self / 60
        let remainingSeconds = self % 60

        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
    }
}

extension TimeInterval {
    /// Milliseconds as `m:ss` text.
    var millisecondsMinuteSecondText: String {
        Int(max(0, self / 1000)).minuteSecondText
    }
}

//
//  Int+DateFormatting.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/1.
//

import Foundation

extension Int {
    /// Seconds as `m:ss` text.
    var minuteSecondText: String {
        let minutes = self / 60
        let remainingSeconds = self % 60

        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    /// Milliseconds since 1970 as `yyyy-MM-dd` text.
    var millisecondsYearMonthDayText: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        return DateFormatter.yearMonthDay.string(from: date)
    }
}

extension TimeInterval {
    /// Milliseconds as `m:ss` text.
    var millisecondsMinuteSecondText: String {
        Int(max(0, self / 1000)).minuteSecondText
    }
}

private extension DateFormatter {
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

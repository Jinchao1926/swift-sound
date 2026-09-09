//
//  Int+Formatting.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

enum CountAbbreviationThreshold {
    case tenThousand
    case hundredThousand

    fileprivate var wanThreshold: Int {
        switch self {
        case .tenThousand:
            return 10_000
        case .hundredThousand:
            return 100_000
        }
    }

    fileprivate var yiThreshold: Int { wanThreshold * 10_000 }
}

extension Int {
    func formattedCount(threshold: CountAbbreviationThreshold = .tenThousand) -> String {
        if self >= threshold.yiThreshold {
            return formattedCount(divisor: 100_000_000, suffix: "亿")
        }

        if self >= threshold.wanThreshold {
            return formattedCount(divisor: 10_000, suffix: "万")
        }

        return "\(self)"
    }

    func formattedSongCount() -> String { "\(self)首" }

    private func formattedCount(divisor: Int, suffix: String) -> String {
        let rawValue = Double(self) / Double(divisor)
        let roundedValue = (rawValue * 10).rounded() / 10
        let valueText: String

        if roundedValue.truncatingRemainder(dividingBy: 1) == 0 {
            valueText = "\(Int(roundedValue))"
        } else {
            valueText = String(format: "%.1f", roundedValue)
        }

        return "\(valueText)\(suffix)"
    }
}

//
//  Int+Formatting.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

extension Int {
    var abbreviatedCountText: String {
        switch self {
        case 100_000_000...:
            return formattedCount(divisor: 100_000_000, suffix: "亿")
        case 10_000..<100_000_000:
            return formattedCount(divisor: 10_000, suffix: "万")
        default:
            return "\(self)"
        }
    }

    var songCountText: String { "\(self)首" }

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

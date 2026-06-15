//
//  Int+PlayCount.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/15.
//

import Foundation

extension Int {
    var playCountText: String {
        if self >= 10_000 {
            return String(format: "%.1f万", Double(self) / 10_000.0)
        }

        return "\(self)"
    }
}

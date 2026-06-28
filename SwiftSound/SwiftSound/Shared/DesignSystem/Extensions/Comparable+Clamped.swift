//
//  Comparable+Clamped.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/27.
//

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

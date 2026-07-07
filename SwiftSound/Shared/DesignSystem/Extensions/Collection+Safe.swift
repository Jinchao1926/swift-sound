//
//  Collection+Safe.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

extension Collection {
    /// Safe indexing, returning nil if out of bounds
    subscript(safe index: Index?) -> Element? {
        guard let index, indices.contains(index) else { return nil }

        return self[index]
    }
}

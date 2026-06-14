//
//  BannerCarouselPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation

struct BannerCarouselLayout {
    static let buttonWidth: CGFloat = 30
}

struct BannerPage<Item: Identifiable>: Identifiable {
    let id: Int
    let items: [Item]
}

extension Array {
    /// Splits the array into chunks with a given maximum size.
    /// - Parameter size: Maximum number of elements per chunk. Must be greater than 0.
    /// - Returns: A two-dimensional array containing the split chunks.
    ///            If `size` is less than or equal to 0, returns an empty array.
    ///
    /// Example:
    /// `[1, 2, 3, 4, 5].bannerChunked(into: 2)` -> `[[1, 2], [3, 4], [5]]`
    func bannerChunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }

        return stride(from: 0, to: count, by: size).map { startIndex in
            Array(self[startIndex..<Swift.min(startIndex + size, count)])
        }
    }
}

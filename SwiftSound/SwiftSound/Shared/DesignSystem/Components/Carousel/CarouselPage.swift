//
//  CarouselPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation

struct CarouselLayout {
    static let buttonWidth: CGFloat = 30
}

struct CarouselPage<Item: Identifiable>: Identifiable {
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
    func carouselChunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }

        return stride(from: 0, to: count, by: size).map { startIndex in
            Array(self[startIndex..<Swift.min(startIndex + size, count)])
        }
    }

    /// Splits the array into pages and backfills an incomplete last page from
    /// previous elements so the last page keeps the requested size when possible.
    ///
    /// Example:
    /// `[1, 2, 3, 4, 5, 6].carouselBackfilledLastPage(into: 4)` -> `[[1, 2, 3, 4], [3, 4, 5, 6]]`
    func carouselBackfilledLastPage(into size: Int) -> [[Element]] {
        var pages = carouselChunked(into: size)
        guard size > 0, count > size, count % size != 0 else { return pages }

        pages[pages.count - 1] = Array(self[(count - size)..<count])
        return pages
    }
}

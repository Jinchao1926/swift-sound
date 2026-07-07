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

    /// Splits the array into pages and backfills an incomplete last page from
    /// previous elements so the last page keeps the requested size when possible.
    ///
    /// Example:
    /// `[1, 2, 3, 4, 5, 6].carouselBackfilledLastPage(into: 4)` -> `[[1, 2, 3, 4], [3, 4, 5, 6]]`
    func carouselBackfilledLastPage(into size: Int) -> [[Element]] {
        var pages = chunked(into: size)
        guard size > 0, count > size, count % size != 0 else { return pages }

        pages[pages.count - 1] = Array(self[(count - size)..<count])
        return pages
    }
}

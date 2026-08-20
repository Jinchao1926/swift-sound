//
//  CarouselConfiguration.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/20.
//

import CoreGraphics
import Foundation

/// 描述 Carousel 的显示和翻页行为。
struct CarouselConfiguration: Equatable {
    let sizing: CarouselItemSizing
    var itemSpacing: CGFloat
    var showsPageIndicators: Bool
    var pagingBehavior: CarouselPagingBehavior
    var autoPaging: CarouselAutoPaging

    init(
        sizing: CarouselItemSizing,
        itemSpacing: CGFloat = 20,
        showsPageIndicators: Bool = true,
        pagingBehavior: CarouselPagingBehavior = .looping,
        autoPaging: CarouselAutoPaging = .interval(4)
    ) {
        self.sizing = sizing
        self.itemSpacing = itemSpacing
        self.showsPageIndicators = showsPageIndicators
        self.pagingBehavior = pagingBehavior
        self.autoPaging = autoPaging
    }
}

/// 定义是否允许从首尾页面循环翻页。
enum CarouselPagingBehavior: Equatable {
    case bounded
    case looping
}

/// 定义 Carousel 是否按固定时间间隔自动翻页。
enum CarouselAutoPaging: Hashable {
    case disabled
    case interval(TimeInterval)

    var interval: TimeInterval? {
        guard case let .interval(value) = self else { return nil }
        return value
    }
}

//
//  CarouselCoordinator+Paging.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/20.
//

/// 提供无状态的分页计算，避免协调器重复实现边界判断。
enum CarouselPagingEngine {
    /// 手动拖拽时选择距离最近的页面；距离相等时保留前一页，避免无意间向前跳页。
    static func nearestPageIndex(to itemIndex: Int, pageStartIndices: [Int]) -> Int {
        guard let firstIndex = pageStartIndices.firstIndex(where: { $0 >= itemIndex }) else {
            return pageStartIndices.indices.last ?? 0
        }
        guard firstIndex > 0 else { return firstIndex }

        let previousIndex = firstIndex - 1
        let previousDistance = abs(itemIndex - pageStartIndices[previousIndex])
        let nextDistance = abs(pageStartIndices[firstIndex] - itemIndex)
        return previousDistance <= nextDistance ? previousIndex : firstIndex
    }

    /// 根据翻页行为处理越过首尾页面的目标页码。
    static func targetPageIndex(
        from pageIndex: Int,
        offset: Int,
        pageCount: Int,
        behavior: CarouselPagingBehavior
    ) -> Int {
        let targetIndex = pageIndex + offset
        guard pageCount > 0 else { return 0 }

        if targetIndex < 0 {
            return behavior == .looping ? pageCount - 1 : 0
        }
        if targetIndex >= pageCount {
            return behavior == .looping ? 0 : pageCount - 1
        }
        return targetIndex
    }
}

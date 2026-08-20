//
//  CarouselLayout.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/20.
//

import CoreGraphics

/// 描述 Carousel 如何根据可用宽度计算卡片尺寸。
enum CarouselItemSizing: Equatable {
    case fixed(CGFloat)
    case flexible(columns: Int, minimum: CGFloat = 0, maximum: CGFloat = .infinity)
    case adaptive(minimum: CGFloat, maximum: CGFloat = .infinity)

    // swiftlint:disable function_body_length
    /// 根据当前容器宽度生成一次完整的布局快照。
    func resolve(
        in availableWidth: CGFloat,
        itemSpacing: CGFloat,
        itemCount: Int
    ) -> CarouselLayoutSnapshot {
        let availableWidth = max(availableWidth, 0)
        let itemSpacing = max(itemSpacing, 0)
        let itemCount = max(itemCount, 0)

        let result: (columns: Int, width: CGFloat)
        switch self {
        case let .fixed(width):
            let itemWidth = max(width, 0)

            // 固定模式保持卡片宽度不变，列数由可用宽度反推：
            // floor((可用宽度 + 间距) / (卡片宽度 + 间距))。
            result = (
                columns: columnsThatFit(
                    itemWidth: itemWidth,
                    availableWidth: availableWidth,
                    itemSpacing: itemSpacing
                ),
                width: min(itemWidth, availableWidth)
            )

        case let .flexible(columns, minimum, maximum):
            let columns = max(columns, 1)

            // 灵活模式固定列数，先均分扣除间距后的空间，再应用最小/最大宽度约束。
            let proposedWidth = flexibleWidth(
                columns: columns,
                availableWidth: availableWidth,
                itemSpacing: itemSpacing
            )
            result = (
                columns: columns,
                width: constrainedWidth(
                    proposedWidth,
                    minimum: minimum,
                    maximum: maximum,
                    availableWidth: availableWidth
                )
            )

        case let .adaptive(minimum, maximum):
            let minimum = max(minimum, 1)
            let maximum = max(maximum, minimum)
            let columns = columnsThatFit(
                itemWidth: minimum,
                availableWidth: availableWidth,
                itemSpacing: itemSpacing
            )

            // 自适应模式先按最小宽度决定列数，再把剩余空间平均分配给这些列。
            let proposedWidth = flexibleWidth(
                columns: columns,
                availableWidth: availableWidth,
                itemSpacing: itemSpacing
            )
            result = (
                columns: columns,
                width: constrainedWidth(
                    proposedWidth,
                    minimum: minimum,
                    maximum: maximum,
                    availableWidth: availableWidth
                )
            )
        }

        return CarouselLayoutSnapshot(
            itemWidth: result.width,
            columns: result.columns,
            pageStartIndices: pageStartIndices(
                itemCount: itemCount,
                columns: result.columns
            )
        )
    }
    // swiftlint:enable function_body_length

    private func columnsThatFit(
        itemWidth: CGFloat,
        availableWidth: CGFloat,
        itemSpacing: CGFloat
    ) -> Int {
        guard availableWidth > 0, itemWidth > 0 else { return 1 }
        return max(Int((availableWidth + itemSpacing) / (itemWidth + itemSpacing)), 1)
    }

    private func flexibleWidth(
        columns: Int,
        availableWidth: CGFloat,
        itemSpacing: CGFloat
    ) -> CGFloat {
        let visibleSpacing = CGFloat(max(columns - 1, 0)) * itemSpacing
        return max((availableWidth - visibleSpacing) / CGFloat(columns), 0)
    }

    private func constrainedWidth(
        _ width: CGFloat,
        minimum: CGFloat,
        maximum: CGFloat,
        availableWidth: CGFloat
    ) -> CGFloat {
        let minimum = min(max(minimum, 0), availableWidth)
        let maximum = min(max(maximum, minimum), availableWidth)
        return width.clamped(to: minimum...maximum)
    }

    /// 页面从每组首个项目开始，最后一页不足一组时从最后可见项目开始。
    private func pageStartIndices(itemCount: Int, columns: Int) -> [Int] {
        guard itemCount > 0 else { return [] }

        let maxStartIndex = max(itemCount - columns, 0)
        guard maxStartIndex > 0 else { return [0] }

        var indices = stride(from: 0, through: maxStartIndex, by: columns).map { $0 }
        if indices.last != maxStartIndex {
            indices.append(maxStartIndex)
        }
        return indices
    }
}

/// 保存当前宽度下可直接用于渲染和翻页的布局结果。
struct CarouselLayoutSnapshot: Equatable {
    let itemWidth: CGFloat
    let columns: Int
    let pageStartIndices: [Int]
}

enum CarouselLayoutMetrics {
    /// 两侧箭头占用的固定宽度，即使箭头隐藏也要保留该空间以避免内容跳动。
    static let navigationControlWidth: CGFloat = 30
}

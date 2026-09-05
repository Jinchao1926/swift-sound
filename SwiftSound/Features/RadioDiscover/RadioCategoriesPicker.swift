//
//  RadioCategoriesPicker.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

struct RadioCategoriesPicker: View {
    let categories: [RadioCategory]

    var body: some View {
        GeometryReader { proxy in
            let width = max(0, proxy.size.width)
            let visibleCount = visibleCategoryCount(for: width)
            let nextCategory = categories.dropFirst(visibleCount).first
            let spacing = actualSpacing(
                for: width,
                visibleCategoryCount: visibleCount,
                showsMore: nextCategory != nil
            )

            HStack(spacing: spacing) {
                RadioCategoryButton("排行榜")
                    .routeLink(to: .radioCharts)

                ForEach(categories.prefix(visibleCount)) { category in
                    RadioCategoryButton(category.name)
                        .routeLink(to: .radioCategories(id: category.id))
                }

                if let nextCategory {
                    RadioCategoryButton("更多", variant: .more)
                        .routeLink(to: .radioCategories(id: nextCategory.id))
                }
            }
            .frame(alignment: .leading)
        }
        .frame(height: RadioCategoryButton.height)
        .frame(maxWidth: .infinity)
    }

    private func visibleCategoryCount(for width: CGFloat) -> Int {
        let categoryCount = categories.count
        guard categoryCount > 0 else { return 0 }

        let allCategoriesWidth = RadioCategoryButton.defaultWidth
            * CGFloat(categoryCount + 1)
        let allCategoriesSpacing = CGFloat(categoryCount) * Layout.itemSpacing

        if width >= allCategoriesWidth + allCategoriesSpacing {
            return categoryCount
        }

        let categorySlotWidth = RadioCategoryButton.defaultWidth + Layout.itemSpacing
        let initialWidth = RadioCategoryButton.defaultWidth + RadioCategoryButton.moreWidth + Layout.itemSpacing

        guard categorySlotWidth > 0, width >= initialWidth else { return 0 }

        return min(
            categoryCount,
            Int((width - initialWidth) / categorySlotWidth)
        )
    }

    private func actualSpacing(
        for width: CGFloat,
        visibleCategoryCount: Int,
        showsMore: Bool
    ) -> CGFloat {
        let buttonWidth = RadioCategoryButton.defaultWidth
            * CGFloat(visibleCategoryCount + 1)
            + (showsMore ? RadioCategoryButton.moreWidth : 0)
        let gapCount = visibleCategoryCount + (showsMore ? 1 : 0)

        guard gapCount > 0 else { return 0 }

        let availableSpacing = (width - buttonWidth) / CGFloat(gapCount)

        return max(Layout.itemSpacing, availableSpacing)
    }
}

private extension RadioCategoriesPicker {
    enum Layout {
        static let itemSpacing: CGFloat = 20
    }
}

#Preview {
    RadioCategoriesPicker(categories: .preview)
        .padding()
        .background(Color.surfacePrimary)
        .environmentObject(AppRouter())
}

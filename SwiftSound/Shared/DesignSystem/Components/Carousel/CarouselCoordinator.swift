//
//  CarouselCoordinator.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/20.
//

import Combine
import CoreGraphics
import SwiftUI

/// 管理 Carousel 的滚动位置、分页状态和布局快照。
final class CarouselCoordinator<ItemID: Hashable>: ObservableObject {
    /// ScrollView 需要直接写入该属性，因此不能限制为 private(set)。
    @Published var leadingItemID: ItemID? {
        didSet {
            guard leadingItemID != oldValue else { return }
            handleLeadingItemChange(leadingItemID)
        }
    }

    @Published private(set) var currentPageIndex = 0
    @Published private(set) var layoutSnapshot: CarouselLayoutSnapshot

    private var itemIDs: [ItemID]
    private var configuration: CarouselConfiguration
    private var availableWidth: CGFloat = 0

    init(itemIDs: [ItemID], configuration: CarouselConfiguration) {
        self.itemIDs = itemIDs
        self.configuration = configuration
        self.leadingItemID = itemIDs.first
        self.layoutSnapshot = configuration.sizing.resolve(
            in: 0,
            itemSpacing: configuration.itemSpacing,
            itemCount: itemIDs.count
        )
    }

    var pageCount: Int {
        layoutSnapshot.pageStartIndices.count
    }

    var hasMultiplePages: Bool {
        pageCount > 1
    }

    var canMoveBackward: Bool {
        configuration.pagingBehavior == .looping || currentPageIndex > 0
    }

    var canMoveForward: Bool {
        configuration.pagingBehavior == .looping || currentPageIndex < pageCount - 1
    }

    var autoPagingTaskID: AutoPagingTaskID {
        AutoPagingTaskID(
            behavior: configuration.autoPaging,
            pageCount: pageCount
        )
    }

    var autoPagingInterval: TimeInterval? {
        configuration.autoPaging.interval
    }

    /// 同步外部数据和配置，只有输入真正变化时才重建布局快照。
    func synchronize(itemIDs: [ItemID], configuration: CarouselConfiguration) {
        let itemsChanged = self.itemIDs != itemIDs
        let configurationChanged = self.configuration != configuration
        guard itemsChanged || configurationChanged else { return }

        self.itemIDs = itemIDs
        self.configuration = configuration
        rebuildLayout()

        if itemsChanged {
            resetToFirstPage()
        } else if configurationChanged {
            restoreVisiblePageAfterLayoutChange()
        }
    }

    /// 几何变化只在实际宽度变化时触发重算，避免每次 body 刷新都重复计算。
    func updateAvailableWidth(_ width: CGFloat) {
        let width = max(width, 0)
        guard abs(availableWidth - width) > 0.5 else { return }

        let previousColumns = layoutSnapshot.columns
        availableWidth = width
        rebuildLayout()

        if previousColumns != layoutSnapshot.columns {
            restoreVisiblePageAfterLayoutChange()
        }
    }

    func resetToFirstPage() {
        currentPageIndex = 0
        leadingItemID = itemIDs.first
    }

    func restoreVisiblePageAfterLayoutChange() {
        guard !itemIDs.isEmpty else {
            resetToFirstPage()
            return
        }

        let visibleItemIndex = leadingItemID.flatMap { itemIDs.firstIndex(of: $0) } ?? 0
        let targetPageIndex = nearestPageIndex(to: visibleItemIndex)
        setPageIndex(targetPageIndex, animated: false)
    }

    func movePage(by offset: Int) {
        guard hasMultiplePages else { return }

        let targetPageIndex = targetPageIndex(from: currentPageIndex, offset: offset)
        guard layoutSnapshot.pageStartIndices.indices.contains(targetPageIndex) else { return }
        setPageIndex(targetPageIndex, animated: true)
    }

    func setPageIndex(_ pageIndex: Int, animated: Bool) {
        guard layoutSnapshot.pageStartIndices.indices.contains(pageIndex) else { return }

        let targetItemIndex = layoutSnapshot.pageStartIndices[pageIndex]
        guard itemIDs.indices.contains(targetItemIndex) else { return }

        currentPageIndex = pageIndex
        let targetItemID = itemIDs[targetItemIndex]
        guard leadingItemID != targetItemID else { return }

        if animated {
            withAnimation(.linear(duration: 0.1)) {
                leadingItemID = targetItemID
            }
        } else {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                leadingItemID = targetItemID
            }
        }
    }

    private func rebuildLayout() {
        let pageWidth = max(availableWidth - CarouselLayoutMetrics.navigationControlWidth * 2, 0)
        layoutSnapshot = configuration.sizing.resolve(
            in: pageWidth,
            itemSpacing: configuration.itemSpacing,
            itemCount: itemIDs.count
        )
    }

    private func handleLeadingItemChange(_ itemID: ItemID?) {
        guard let itemID, let itemIndex = itemIDs.firstIndex(of: itemID) else {
            currentPageIndex = 0
            return
        }
        currentPageIndex = nearestPageIndex(to: itemIndex)
    }

    private func nearestPageIndex(to itemIndex: Int) -> Int {
        CarouselPagingEngine.nearestPageIndex(
            to: itemIndex,
            pageStartIndices: layoutSnapshot.pageStartIndices
        )
    }

    private func targetPageIndex(from pageIndex: Int, offset: Int) -> Int {
        CarouselPagingEngine.targetPageIndex(
            from: pageIndex,
            offset: offset,
            pageCount: pageCount,
            behavior: configuration.pagingBehavior
        )
    }
}

extension CarouselCoordinator {
    struct AutoPagingTaskID: Hashable {
        let behavior: CarouselAutoPaging
        let pageCount: Int
    }
}

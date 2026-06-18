//
//  Carousel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Combine
import SwiftUI

struct Carousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let columns: Int
    let spacing: CGFloat
    let showsDots: Bool
    let isAutoScrollEnabled: Bool
    let isInfiniteLoopEnabled: Bool
    let isLastPageBackfillEnabled: Bool
    let autoScrollInterval: TimeInterval
    let content: (Item) -> Content

    @State private var isHovering = false
    @State private var availableWidth: CGFloat = 0

    /// Page identifier bound to scrollPosition, controls ScrollView scrolling.
    /// Optional because it will be nil before the scroll view finishes layout.
    @State private var displayPageID: Int?

    /// Logical page index for business logic and UI display (e.g. page dots).
    @State private var logicalPageIndex = 0

    // MARK: - LifeCycle
    init(
        items: [Item],
        columns: Int = 2,
        spacing: CGFloat = 20,
        showsDots: Bool = true,
        isAutoScrollEnabled: Bool = true,
        isInfiniteLoopEnabled: Bool = true,
        isLastPageBackfillEnabled: Bool = false,
        autoScrollInterval: TimeInterval = 4,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.columns = max(columns, 1)
        self.spacing = spacing
        self.showsDots = showsDots
        self.isAutoScrollEnabled = isAutoScrollEnabled
        self.isInfiniteLoopEnabled = isInfiniteLoopEnabled
        self.isLastPageBackfillEnabled = isLastPageBackfillEnabled
        self.autoScrollInterval = autoScrollInterval
        self.content = content
    }

    // MARK: - View
    var body: some View {
        VStack(spacing: 6) {
            let contentHorizontalInset = CarouselLayout.buttonWidth
            let pageWidth = max(availableWidth - contentHorizontalInset * 2, 0)
            let itemWidth = itemWidth(in: pageWidth)

            HStack(spacing: 0) {
                CarouselPageButton(
                    systemName: "chevron.left",
                    isVisible: shouldShowControls,
                    isEnabled: canMoveBackward
                ) {
                    movePage(by: -1)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(displayPages) { page in
                            HStack(spacing: spacing) {
                                ForEach(page.items) { item in
                                    content(item)
                                        .frame(width: itemWidth)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }

                                if page.items.count < columns {
                                    ForEach(0..<(columns - page.items.count), id: \.self) { _ in
                                        Color.clear
                                            .frame(width: itemWidth)
                                    }
                                }
                            }
                            .frame(width: pageWidth, alignment: .leading)
                            .id(page.id)
                        }
                    }
                    .scrollTargetLayout()
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $displayPageID, anchor: .leading)
                .onChange(of: displayPageID) { _, newValue in
                    handleDisplayPageChange(newValue)
                }

                CarouselPageButton(
                    systemName: "chevron.right",
                    isVisible: shouldShowControls,
                    isEnabled: canMoveForward
                ) {
                    movePage(by: 1)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onHover { isHovering = $0 }
            .background(widthReader)
            .onAppear {
                resetToFirstPage()
            }
            .onChange(of: items.map(\.id)) { _, _ in
                resetToFirstPage()
            }
            .onReceive(autoScrollTimer) { _ in
                guard shouldAutoScroll else { return }
                movePage(by: 1)
            }

            if shouldShowDots {
                CarouselDots(pageCount: pageCount, currentPageIndex: logicalPageIndex)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Private
private extension Carousel {
    var pages: [CarouselPage<Item>] {
        let pageItems = shouldBackfillLastPage
            ? items.carouselBackfilledLastPage(into: columns)
            : items.chunked(into: columns)

        return pageItems.enumerated().map { index, items in
            // Real page index starts with 1
            CarouselPage(id: index + 1, items: items)
        }
    }

    var displayPages: [CarouselPage<Item>] {
        guard shouldUseLoopNodes, let firstPage = pages.first, let lastPage = pages.last else {
            return pages
        }

        let leadingNode = CarouselPage(id: 0, items: lastPage.items)
        let trailingNode = CarouselPage(id: pageCount + 1, items: firstPage.items)

        // Sentinel pages make edge scrolling feel continuous. Crossing one is
        // corrected back to the matching real page without animation.
        return [leadingNode] + pages + [trailingNode]
    }

    var pageCount: Int { pages.count }
    var hasMultiplePages: Bool { pageCount > 1 }
    var shouldShowControls: Bool { hasMultiplePages && isHovering }
    var shouldShowDots: Bool { showsDots && hasMultiplePages }
    var shouldUseLoopNodes: Bool { isInfiniteLoopEnabled && hasMultiplePages }
    var shouldBackfillLastPage: Bool { isLastPageBackfillEnabled && !isInfiniteLoopEnabled }
    var shouldAutoScroll: Bool { isAutoScrollEnabled && hasMultiplePages && autoScrollInterval > 0 }
    var canMoveBackward: Bool { isInfiniteLoopEnabled || logicalPageIndex > 0 }
    var canMoveForward: Bool { isInfiniteLoopEnabled || logicalPageIndex < pageCount - 1 }

    var autoScrollTimer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: max(autoScrollInterval, 1), on: .main, in: .common).autoconnect()
    }

    var widthReader: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    availableWidth = proxy.size.width
                }
                .onChange(of: proxy.size.width) { _, newValue in
                    availableWidth = newValue
                }
        }
    }

    func itemWidth(in pageWidth: CGFloat) -> CGFloat {
        let visibleSpacing = CGFloat(max(columns - 1, 0)) * spacing
        return max((pageWidth - visibleSpacing) / CGFloat(columns), 0)
    }
}

// MARK: - Private - Page Changes
private extension Carousel {
    func resetToFirstPage() {
        logicalPageIndex = 0
        let firstPageID = pages.first?.id
        guard displayPageID != firstPageID else { return }
        displayPageID = firstPageID
    }

    func movePage(by offset: Int) {
        guard hasMultiplePages else { return }

        let currentRealPageID = normalizedRealPageID(from: displayPageID)
        let targetDisplayPageID = targetDisplayPageID(from: currentRealPageID, offset: offset)
        guard displayPageID != targetDisplayPageID else { return }

        withAnimation(.linear(duration: 0.1)) {
            displayPageID = targetDisplayPageID
        }
    }

    func handleDisplayPageChange(_ newValue: Int?) {
        guard pageCount > 0, let newValue else { return }

        if !hasMultiplePages {
            logicalPageIndex = 0
            return
        }

        if shouldUseLoopNodes, newValue <= 0 {
            logicalPageIndex = pageCount - 1
            jumpToDisplayPage(pageCount)
        } else if shouldUseLoopNodes, newValue >= pageCount + 1 {
            logicalPageIndex = 0
            jumpToDisplayPage(1)
        } else {
            logicalPageIndex = min(max(newValue - 1, 0), pageCount - 1)
        }
    }

    func jumpToDisplayPage(_ pageID: Int) {
        guard displayPageID != pageID else { return }

        DispatchQueue.main.async {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                displayPageID = pageID
            }
        }
    }

    func normalizedRealPageID(from displayPageID: Int?) -> Int {
        let fallbackPageID = min(max(logicalPageIndex + 1, 1), pageCount)
        guard let displayPageID else { return fallbackPageID }

        if shouldUseLoopNodes, displayPageID <= 0 {
            return pageCount
        }

        if shouldUseLoopNodes, displayPageID >= pageCount + 1 {
            return 1
        }

        return displayPageID
    }

    func targetDisplayPageID(from realPageID: Int, offset: Int) -> Int {
        let targetPageID = realPageID + offset

        if targetPageID < 1 {
            return isInfiniteLoopEnabled ? 0 : 1
        }

        if targetPageID > pageCount {
            return isInfiniteLoopEnabled ? pageCount + 1 : pageCount
        }

        return targetPageID
    }
}

private struct BannerPreviewItem: Identifiable {
    let value: Int
    var id: Int { value }
}

#Preview {
    // Case 1
    Carousel(
        items: [1, 2, 3, 4, 5, 6].compactMap { BannerPreviewItem(value: $0) }
    ) { item in
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue.opacity(0.2))
            .overlay(
                Text(String(describing: item.value))
                    .font(.title)
                    .foregroundColor(.blue)
            )
    }
    .frame(width: 760, height: 164)
    .padding(10)

    Divider()

    // Case 2
    Carousel(
        items: [1, 2, 3, 4, 5, 6].compactMap { BannerPreviewItem(value: $0) },
        columns: 4,
        showsDots: false,
        isAutoScrollEnabled: false,
        isInfiniteLoopEnabled: false,
        isLastPageBackfillEnabled: true,
    ) { item in
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue.opacity(0.2))
            .overlay(
                Text(String(describing: item.value))
                    .font(.title)
                    .foregroundColor(.blue)
            )
    }
    .frame(width: 760, height: 164)
    .padding(10)
}

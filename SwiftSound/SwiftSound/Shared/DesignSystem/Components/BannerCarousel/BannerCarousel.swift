//
//  BannerCarousel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Combine
import SwiftUI

struct BannerCarousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let columns: Int
    let spacing: CGFloat
    let autoScrollInterval: TimeInterval
    let content: (Item) -> Content

    /// Page identifier bound to scrollPosition, controls ScrollView scrolling.
    /// Optional because it will be nil before the scroll view finishes layout.
    @State private var displayPageID: Int?

    /// Logical page index for business logic and UI display (e.g. page dots).
    @State private var logicalPageIndex = 1

    // MARK: - LifeCycle
    init(
        items: [Item],
        columns: Int = 2,
        spacing: CGFloat = 20,
        autoScrollInterval: TimeInterval = 4,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.columns = max(columns, 1)
        self.spacing = spacing
        self.autoScrollInterval = autoScrollInterval
        self.content = content
    }

    // MARK: - View
    var body: some View {
        VStack(spacing: 6) {
            GeometryReader { proxy in
                let contentHorizontalInset = shouldShowControls ? BannerCarouselLayout.buttonWidth : 0
                let pageWidth = max(proxy.size.width - contentHorizontalInset * 2, 0)
                let itemWidth = itemWidth(in: pageWidth)

                HStack(spacing: 0) {
                    if shouldShowControls {
                        BannerCarouselPageButton(systemName: "chevron.left") {
                            movePage(by: -1)
                        }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        // Page
                        LazyHStack(spacing: 0) {
                            ForEach(displayPages) { page in
                                // Page items
                                HStack(spacing: spacing) {
                                    ForEach(page.items) { item in
                                        content(item)
                                            .frame(width: itemWidth, height: proxy.size.height)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }

                                    // Fill in the blank
                                    if page.items.count < columns {
                                        ForEach(0..<(columns - page.items.count), id: \.self) { _ in
                                            Color.clear
                                                .frame(width: itemWidth, height: proxy.size.height)
                                        }
                                    }
                                }
                                .frame(width: pageWidth, height: proxy.size.height, alignment: .leading)
                                .id(page.id)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .frame(width: pageWidth, height: proxy.size.height)
                    .scrollTargetBehavior(.paging)  // 开启整页分页滚动行为
                    .scrollPosition(id: $displayPageID) // 编程式控制滚动位置，需要绑定 id
                    .onChange(of: displayPageID) { _, newValue in
                        handleDisplayPageChange(newValue)
                    }

                    if shouldShowControls {
                        BannerCarouselPageButton(systemName: "chevron.right") {
                            movePage(by: 1)
                        }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onAppear {
                    resetToFirstPage()
                }
                .onChange(of: items.map(\.id)) { _, _ in
                    // 数据源变化
                    resetToFirstPage()
                }
                .onReceive(autoScrollTimer) { _ in
                    guard shouldAutoScroll else { return }
                    movePage(by: 1)
                }
            }

            if pageCount > 1 {
                BannerCarouselDots(pageCount: pageCount, currentPageIndex: logicalPageIndex)
            }
        }
    }
}

// MARK: - Private
private extension BannerCarousel {
    var pages: [BannerPage<Item>] {
        items.bannerChunked(into: columns).enumerated().map { index, items in
            // Real page index starts with 1
            BannerPage(id: index + 1, items: items)
        }
    }

    var displayPages: [BannerPage<Item>] {
        guard pageCount > 1, let firstPage = pages.first, let lastPage = pages.last else {
            return pages
        }

        let leadingNode = BannerPage(id: 0, items: lastPage.items)
        let trailingNode = BannerPage(id: pageCount + 1, items: firstPage.items)

        // 0, [1, 2, ...count-1], count
        return [leadingNode] + pages + [trailingNode]
    }

    var pageCount: Int { pages.count }
    var shouldShowControls: Bool { pageCount > 1 }
    var shouldAutoScroll: Bool { pageCount > 1 && autoScrollInterval > 0 }

    var autoScrollTimer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: max(autoScrollInterval, 1), on: .main, in: .common).autoconnect()
    }

    func itemWidth(in pageWidth: CGFloat) -> CGFloat {
        let visibleSpacing = CGFloat(max(columns - 1, 0)) * spacing
        return max((pageWidth - visibleSpacing) / CGFloat(columns), 0)
    }
}

// MARK: - Private - Page Changes
private extension BannerCarousel {
    func resetToFirstPage() {
        logicalPageIndex = 0
        displayPageID = pageCount > 1 ? 1 : pages.first?.id
    }

    func movePage(by offset: Int) {
        guard pageCount > 1 else { return }

        let currentDisplayPageID = displayPageID ?? logicalPageIndex + 1
        let targetDisplayPageID = currentDisplayPageID + offset

        withAnimation(.easeInOut(duration: 0.28)) {
            displayPageID = targetDisplayPageID
        }
    }

    func handleDisplayPageChange(_ newValue: Int?) {
        guard pageCount > 0, let newValue else { return }

        if pageCount == 1 {
            logicalPageIndex = 0
            return
        }

        if newValue == 0 {
            logicalPageIndex = pageCount - 1
            jumpToDisplayPage(pageCount)
        } else if newValue == pageCount + 1 {
            logicalPageIndex = 0
            jumpToDisplayPage(1)
        } else {
            logicalPageIndex = min(max(newValue - 1, 0), pageCount - 1)
        }
    }

    func jumpToDisplayPage(_ pageID: Int) {
        DispatchQueue.main.async {
            var transaction = Transaction()
            transaction.disablesAnimations = true

            withTransaction(transaction) {
                displayPageID = pageID
            }
        }
    }
}

private struct BannerPreviewItem: Identifiable {
    let value: Int

    var id: Int { value }
}

#Preview {
    BannerCarousel(items: [1, 2, 3, 4, 5, 6].compactMap { BannerPreviewItem(value: $0)}) { item in
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue.opacity(0.2))
            .overlay(
                Text(String(describing: item.value))
                    .font(.title)
                    .foregroundColor(.blue)
            )
    }
    .frame(width: 760, height: 164)
}

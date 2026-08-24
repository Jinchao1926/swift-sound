//
//  PaginationControl.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/24.
//

import SwiftUI

struct PaginationControl: View {
    @Binding var currentPage: Int
    let pageCount: Int
    var isEnabled = true

    @State private var pageInput = ""

    var body: some View {
        HStack(spacing: PaginationLayout.Control.itemSpacing) {
            navigationButton(
                systemName: "chevron.left",
                targetPage: currentPage - 1,
                isAvailable: currentPage > 1
            )

            ForEach(Array(visibleItems.enumerated()), id: \.offset) { _, item in
                switch item {
                case .page(let page):
                    pageButton(page)
                case .ellipsis:
                    ellipsisView
                }
            }

            navigationButton(
                systemName: "chevron.right",
                targetPage: currentPage + 1,
                isAvailable: currentPage < pageCount
            )

            if pageCount > PaginationLayout.PageRange.maxPageCountWithoutEllipsis {
                PaginationJumpControl(
                    pageInput: $pageInput,
                    isEnabled: isEnabled,
                    action: jumpToPage
                )
            }
        }
    }

    private var ellipsisView: some View {
        Text("...")
            .font(.font12.weight(.medium))
            .foregroundStyle(Color.textSecondary)
            .frame(width: PaginationLayout.Control.itemWidth, height: PaginationLayout.Control.itemHeight)
    }

    private func pageButton(_ page: Int) -> some View {
        PaginationPageButton(
            page: page,
            isSelected: page == currentPage,
            isEnabled: isEnabled
        ) {
            currentPage = page
        }
    }

    private func navigationButton(
        systemName: String,
        targetPage: Int,
        isAvailable: Bool
    ) -> some View {
        let canNavigate = isEnabled && isAvailable

        return Button {
            currentPage = targetPage
        } label: {
            Image(systemName: systemName)
                .font(.font11.weight(.semibold))
                .foregroundStyle(canNavigate ? Color.textSecondary : Color.textTertiary.opacity(0.5))
                .frame(width: PaginationLayout.Control.itemWidth, height: PaginationLayout.Control.itemHeight)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!canNavigate)
        .pointerStyle(canNavigate ? .link : .default)
    }
}

private extension PaginationControl {
    var visibleItems: [PageItem] {
        let totalPageCount = max(1, pageCount)

        // 页数较少时完整展示，避免不必要的省略号和跳转输入框。
        guard totalPageCount > PaginationLayout.PageRange.maxPageCountWithoutEllipsis else {
            return pageItems(in: 1...totalPageCount)
        }

        let selectedPage = min(max(currentPage, 1), totalPageCount)
        let pageRange = PaginationLayout.PageRange.self

        // 页数较多时固定保留第一页和最后一页，中间根据当前页动态取邻居页。
        // 当前页靠近起始位置时，展示前段页码并省略后段页码。
        if selectedPage <= pageRange.boundaryThreshold {
            return leadingPageItems(lastPage: totalPageCount)
        }

        // 当前页靠近末尾时，展示后段页码并省略前段页码。
        if selectedPage > totalPageCount - pageRange.boundaryThreshold {
            return trailingPageItems(lastPage: totalPageCount)
        }

        return middlePageItems(selectedPage: selectedPage, lastPage: totalPageCount)
    }

    private func pageItems(in range: ClosedRange<Int>) -> [PageItem] {
        range.map(PageItem.page)
    }

    private func leadingPageItems(lastPage: Int) -> [PageItem] {
        let pageRange = PaginationLayout.PageRange.self
        return pageItems(in: 1...pageRange.boundaryPageCount)
            + [.ellipsis(.trailing), .page(lastPage)]
    }

    private func trailingPageItems(lastPage: Int) -> [PageItem] {
        let pageRange = PaginationLayout.PageRange.self
        let startPage = lastPage - pageRange.boundaryPageCount + 1
        return [.page(1), .ellipsis(.leading)]
            + pageItems(in: startPage...lastPage)
    }

    private func middlePageItems(selectedPage: Int, lastPage: Int) -> [PageItem] {
        let pageRange = PaginationLayout.PageRange.self
        let startPage = selectedPage - pageRange.neighborRadius
        let endPage = selectedPage + pageRange.neighborRadius
        return [.page(1), .ellipsis(.leading)]
            + pageItems(in: startPage...endPage)
            + [.ellipsis(.trailing), .page(lastPage)]
    }

    private func jumpToPage() {
        defer { pageInput = "" }
        guard let requestedPage = Int(pageInput), requestedPage > 0 else { return }
        currentPage = min(requestedPage, max(1, pageCount))
    }
}

private enum PageItem: Hashable {
    enum EllipsisPosition: Hashable {
        case leading
        case trailing
    }

    case page(Int)
    case ellipsis(EllipsisPosition)
}

private struct PaginationPreview: View {
    @State private var currentPage: Int
    let pageCount: Int
    let isEnabled: Bool

    init(currentPage: Int, pageCount: Int, isEnabled: Bool = true) {
        _currentPage = State(initialValue: currentPage)
        self.pageCount = pageCount
        self.isEnabled = isEnabled
    }

    var body: some View {
        PaginationControl(
            currentPage: $currentPage,
            pageCount: pageCount,
            isEnabled: isEnabled
        )
        .padding()
    }
}

#Preview {
    VStack {
        PaginationPreview(currentPage: 2, pageCount: 5)

        PaginationPreview(currentPage: 1, pageCount: 40)

        PaginationPreview(currentPage: 20, pageCount: 40)

        PaginationPreview(currentPage: 40, pageCount: 40)

        PaginationPreview(currentPage: 2, pageCount: 40, isEnabled: false)
    }
}

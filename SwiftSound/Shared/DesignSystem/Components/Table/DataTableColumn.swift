//
//  DataTableColumn.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

enum DataTableColumnWidth {
    case fixed(CGFloat)
    case flexible(min: CGFloat, ideal: CGFloat? = nil, max: CGFloat? = nil)
}

enum DataTableColumnVisibility {
    case always
    case rowHoverOnly
}

struct DataTableRowContext {
    let index: Int
    let isHovering: Bool
    let isHighlighted: Bool
}

struct DataTableColumn<Row>: Identifiable {
    let id: String
    let title: String
    let width: DataTableColumnWidth
    let alignment: Alignment
    let visibility: DataTableColumnVisibility
    let sortComparator: ((Row, Row) -> ComparisonResult)?
    let content: (Row, DataTableRowContext) -> AnyView

    init<Content: View>(
        id: String,
        title: String,
        width: DataTableColumnWidth,
        alignment: Alignment = .leading,
        visibility: DataTableColumnVisibility = .always,
        sortComparator: ((Row, Row) -> ComparisonResult)? = nil,
        @ViewBuilder content: @escaping (Row, DataTableRowContext) -> Content
    ) {
        self.id = id
        self.title = title
        self.width = width
        self.alignment = alignment
        self.visibility = visibility
        self.sortComparator = sortComparator
        self.content = { row, context in AnyView(content(row, context)) }
    }

    var isSortable: Bool { sortComparator != nil }

    func isVisible(context: DataTableRowContext) -> Bool {
        switch visibility {
        case .always:
            return true
        case .rowHoverOnly:
            return context.isHovering
        }
    }
}

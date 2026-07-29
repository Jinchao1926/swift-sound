//
//  DataTable.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/29.
//

import SwiftUI

struct DataTable<Row: Identifiable>: View where Row.ID: Hashable {
    let rows: [Row]
    let columns: [DataTableColumn<Row>]
    let style: DataTableStyle

    @State private var hoveredRowID: Row.ID?
    @State private var sortState = DataTableSortState()

    init(
        rows: [Row],
        columns: [DataTableColumn<Row>],
        style: DataTableStyle = .plain
    ) {
        self.rows = rows
        self.columns = columns
        self.style = style
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            LazyVStack(spacing: style.rowSpacing) {
                ForEach(sortedRows) { row in
                    dataRow(row)
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: style.columnSpacing) {
            ForEach(columns) { column in
                DataTableHeaderCell(
                    column: column,
                    sortState: $sortState,
                    style: style
                )
                .dataTableColumnFrame(column.width, alignment: column.alignment)
            }
        }
        .frame(height: style.headerHeight)
        .padding(.horizontal, style.horizontalPadding)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(style.divider)
                .frame(height: 1)
        }
    }

    private func dataRow(_ row: DataTableIndexedRow<Row>) -> some View {
        let isHovering = hoveredRowID == row.value.id
        let context = DataTableRowContext(
            originalIndex: row.originalIndex,
            isHovering: isHovering
        )

        return HStack(spacing: style.columnSpacing) {
            ForEach(columns) { column in
                column.content(row.value, context)
                    .opacity(column.isVisible(context: context) ? 1 : 0)
                    .allowsHitTesting(column.isVisible(context: context))
                    .dataTableColumnFrame(column.width, alignment: column.alignment)
            }
        }
        .frame(height: style.rowHeight)
        .padding(.horizontal, style.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .fill(isHovering ? style.hoverFill : style.normalFill)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            hoveredRowID = hovering ? row.value.id : nil
        }
    }

    private var sortedRows: [DataTableIndexedRow<Row>] {
        var indexedRows = rows.enumerated().map {
            DataTableIndexedRow(originalIndex: $0.offset, value: $0.element)
        }

        guard
            let columnID = sortState.columnID,
            let order = sortState.order,
            let column = columns.first(where: { $0.id == columnID }),
            let compare = column.compare
        else {
            return indexedRows
        }

        indexedRows.sort { lhs, rhs in
            let result = compare(lhs.value, rhs.value)
            let stableResult = result == .orderedSame
                ? lhs.originalIndex.compare(rhs.originalIndex)
                : result

            switch order {
            case .ascending:
                return stableResult == .orderedAscending
            case .descending:
                return stableResult == .orderedDescending
            }
        }

        return indexedRows
    }
}

struct DataTableColumn<Row>: Identifiable {
    let id: String
    let title: String
    let width: DataTableColumnWidth
    let alignment: Alignment
    let visibility: DataTableColumnVisibility
    let compare: ((Row, Row) -> ComparisonResult)?
    let content: (Row, DataTableRowContext) -> AnyView

    init<Content: View>(
        id: String,
        title: String,
        width: DataTableColumnWidth,
        alignment: Alignment = .leading,
        visibility: DataTableColumnVisibility = .always,
        sort: ((Row, Row) -> ComparisonResult)? = nil,
        @ViewBuilder content: @escaping (Row, DataTableRowContext) -> Content
    ) {
        self.id = id
        self.title = title
        self.width = width
        self.alignment = alignment
        self.visibility = visibility
        self.compare = sort
        self.content = { row, context in AnyView(content(row, context)) }
    }

    var isSortable: Bool {
        compare != nil
    }

    func isVisible(context: DataTableRowContext) -> Bool {
        switch visibility {
        case .always:
            return true
        case .rowHoverOnly:
            return context.isHovering
        }
    }
}

enum DataTableColumnWidth {
    case fixed(CGFloat)
    case flexible(min: CGFloat, ideal: CGFloat? = nil, max: CGFloat? = nil)
}

enum DataTableColumnVisibility {
    case always
    case rowHoverOnly
}

struct DataTableRowContext {
    let originalIndex: Int
    let isHovering: Bool
}

struct DataTableStyle {
    let headerHeight: CGFloat
    let rowHeight: CGFloat
    let horizontalPadding: CGFloat
    let columnSpacing: CGFloat
    let rowSpacing: CGFloat
    let cornerRadius: CGFloat
    let normalFill: Color
    let hoverFill: Color
    let divider: Color
    let headerForeground: Color
    let activeHeaderForeground: Color

    static let plain = DataTableStyle(
        headerHeight: 38,
        rowHeight: 64,
        horizontalPadding: 0,
        columnSpacing: 0,
        rowSpacing: 0,
        cornerRadius: 6,
        normalFill: .clear,
        hoverFill: .white,
        divider: Color.divider.opacity(0.55),
        headerForeground: Color.textSecondary,
        activeHeaderForeground: Color.textPrimary
    )
}

private struct DataTableIndexedRow<Row: Identifiable>: Identifiable {
    let originalIndex: Int
    let value: Row

    var id: Row.ID { value.id }
}

private struct DataTableSortState {
    var columnID: String?
    var order: DataTableSortOrder?

    mutating func advance(columnID selectedColumnID: String) {
        guard columnID == selectedColumnID else {
            columnID = selectedColumnID
            order = .ascending
            return
        }

        switch order {
        case .none:
            order = .ascending
        case .ascending:
            order = .descending
        case .descending:
            columnID = nil
            order = nil
        }
    }
}

private enum DataTableSortOrder {
    case ascending
    case descending

    var systemImage: String {
        switch self {
        case .ascending:
            return "chevron.up"
        case .descending:
            return "chevron.down"
        }
    }
}

private struct DataTableHeaderCell<Row: Identifiable>: View {
    let column: DataTableColumn<Row>
    @Binding var sortState: DataTableSortState
    let style: DataTableStyle

    @State private var isHovering = false

    var body: some View {
        Button {
            guard column.isSortable else { return }
            sortState.advance(columnID: column.id)
        } label: {
            HStack(spacing: 4) {
                if column.alignment == .trailing {
                    Spacer(minLength: 0)
                }

                Text(column.title)
                    .lineLimit(1)

                if isActive, let order = sortState.order {
                    Image(systemName: order.systemImage)
                        .font(.font9)
                }

                if column.alignment == .leading {
                    Spacer(minLength: 0)
                }
            }
            .font(.font12)
            .foregroundStyle(isActive ? style.activeHeaderForeground : style.headerForeground)
            .frame(maxWidth: .infinity, alignment: column.alignment)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!column.isSortable)
        .onHover { isHovering = $0 }
        .pointerStyle(column.isSortable ? .link : .default)
        .opacity(isHovering || isActive || !column.isSortable ? 1 : 0.82)
    }

    private var isActive: Bool {
        sortState.columnID == column.id && sortState.order != nil
    }
}

private extension View {
    @ViewBuilder
    func dataTableColumnFrame(
        _ width: DataTableColumnWidth,
        alignment: Alignment
    ) -> some View {
        switch width {
        case .fixed(let width):
            frame(width: width, alignment: alignment)
        case .flexible(let min, let ideal, let max):
            frame(
                minWidth: min,
                idealWidth: ideal,
                maxWidth: max ?? .infinity,
                alignment: alignment
            )
        }
    }
}

private extension Int {
    func compare(_ other: Int) -> ComparisonResult {
        if self < other { return .orderedAscending }
        if self > other { return .orderedDescending }
        return .orderedSame
    }
}

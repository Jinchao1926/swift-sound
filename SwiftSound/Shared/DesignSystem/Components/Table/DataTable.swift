//
//  DataTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
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
            dataHeader

            LazyVStack(spacing: 0) {
                ForEach(Array(sortedRows.enumerated()), id: \.element.id) { index, row in
                    dataRow(row, index: index)
                }
            }
        }
    }

    private var dataHeader: some View {
        HStack(spacing: 0) {
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
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(style.divider)
                .frame(height: 1)
        }
    }

    private func dataRow(_ row: DataTableRow<Row>, index: Int) -> some View {
        let isHovering = hoveredRowID == row.value.id
        let context = DataTableRowContext(
            index: index,
            isHovering: isHovering
        )

        return HStack(spacing: 0) {
            ForEach(columns) { column in
                column.content(row.value, context)
                    .opacity(column.isVisible(context: context) ? 1 : 0)
                    .allowsHitTesting(column.isVisible(context: context))
                    .dataTableColumnFrame(column.width, alignment: column.alignment)
            }
        }
        .frame(height: style.rowHeight)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .fill(isHovering ? style.hoverFill : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            hoveredRowID = hovering ? row.value.id : nil
        }
    }

    private var sortedRows: [DataTableRow<Row>] {
        var tableRows = rows.enumerated().map {
            DataTableRow(sourceOrder: $0.offset, value: $0.element)
        }

        guard
            let columnID = sortState.columnID,
            let order = sortState.order,
            let column = columns.first(where: { $0.id == columnID }),
            let compare = column.compare
        else {
            return tableRows
        }

        tableRows.sort { lhs, rhs in
            let result = compare(lhs.value, rhs.value)
            let stableResult = result == .orderedSame
                ? lhs.sourceOrder.compare(rhs.sourceOrder)
                : result

            switch order {
            case .ascending:
                return stableResult == .orderedAscending
            case .descending:
                return stableResult == .orderedDescending
            }
        }

        return tableRows
    }
}

private struct DataTableRow<Row: Identifiable>: Identifiable {
    let sourceOrder: Int
    let value: Row

    var id: Row.ID { value.id }
}

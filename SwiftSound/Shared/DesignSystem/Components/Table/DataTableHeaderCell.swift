//
//  DataTableHeaderCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct DataTableHeaderCell<Row: Identifiable>: View {
    let column: DataTableColumn<Row>
    @Binding var sortState: DataTableSortState
    let style: DataTableStyle

    @State private var isHovering = false

    var body: some View {
        Button {
            guard column.isSortable else { return }
            sortState.cycle(columnID: column.id)
        } label: {
            headerContent
            .font(.font13)
            .foregroundStyle(style.headerForeground)
            .padding(.horizontal, style.cellHorizontalPadding)
            .frame(maxWidth: .infinity, alignment: column.alignment)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: style.headerCornerRadius, style: .continuous)
                    .fill(showsHoverBackground ? style.headerHoverFill : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(column.isSortable ? .link : .default)
        .opacity(column.isSortable && !isHovering && !isActive ? 0.82 : 1)
    }

    @ViewBuilder
    private var headerContent: some View {
        if showsSortStatus {
            ViewThatFits(in: .horizontal) {
                headerContent(sortStatus: sortStatusLabel)
                headerContent(sortStatus: sortStatusIcon)
            }
        } else {
            headerContent(sortStatus: EmptyView())
        }
    }

    private func headerContent<SortStatus: View>(
        sortStatus: SortStatus
    ) -> some View {
        HStack(spacing: 10) {
            if column.alignment == .trailing {
                Spacer(minLength: 0)
            }

            Text(column.title)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)

            sortStatus

            if column.alignment == .leading {
                Spacer(minLength: 0)
            }
        }
    }

    private var sortStatusLabel: some View {
        HStack(spacing: 2) {
            sortStatusIcon

            Text(sortDisplayState.title)
                .font(.font13)
        }
    }

    private var sortStatusIcon: some View {
        Image(systemName: sortDisplayState.systemImage)
            .font(.font10)
    }

    private var showsSortStatus: Bool {
        column.isSortable && (isHovering || isActive)
    }

    private var showsHoverBackground: Bool {
        column.isSortable && isHovering
    }

    private var sortDisplayState: DataTableSortDisplayState {
        DataTableSortDisplayState(order: isActive ? sortState.order : nil)
    }

    private var isActive: Bool {
        sortState.columnID == column.id && sortState.order != nil
    }

    private var height: CGFloat { 26 }
}

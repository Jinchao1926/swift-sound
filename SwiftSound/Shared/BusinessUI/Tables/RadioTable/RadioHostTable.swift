//
//  RadioHostTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioHostTable: View {
    let hosts: [RadioHost]

    var body: some View {
        DataTable(
            rows: rows,
            columns: columns,
            style: .plain,
            isRowHighlighted: { _ in false }
        )
    }
}

private extension RadioHostTable {
    var rows: [RadioHostTableRow] {
        hosts.map { RadioHostTableRow(host: $0) }
    }

    var columns: [DataTableColumn<RadioHostTableRow>] {
        [indexColumn, titleColumn, followedCountColumn]
    }
}

// MARK: - Columns
private extension RadioHostTable {
    var indexColumn: DataTableColumn<RadioHostTableRow> {
        DataTableColumn(
            id: "index",
            title: "#",
            width: .fixed(Layout.indexWidth),
            alignment: .center,
            content: { row, context in
                RadioHostIndexCell(index: context.rowNumber)
            }
        )
    }

    var titleColumn: DataTableColumn<RadioHostTableRow> {
        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: Layout.titleMinWidth),
            alignment: .leading,
            content: { row, _ in
                RadioHostTableTitleCell(
                    imageURL: row.imageURL,
                    title: row.title
                )
            }
        )
    }

    var followedCountColumn: DataTableColumn<RadioHostTableRow> {
        DataTableColumn(
            id: "followedCount",
            title: "粉丝数",
            width: .fixed(Layout.followedCountWidth),
            content: { row, _ in
                Text(row.followedCount)
                    .font(.font13)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
        )
    }
}

// MARK: - Layout
private extension RadioHostTable {
    enum Layout {
        static let indexWidth: CGFloat = 54
        static let titleMinWidth: CGFloat = 160
        static let followedCountWidth: CGFloat = 70
    }
}

#Preview {
    RadioHostTable(hosts: [.preview, .preview1])
        .padding(20)
        .frame(width: 800)
        .background(Color.surfaceSecondary)
}

//
//  DataTablePreview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

private struct DataTablePreviewRow: Identifiable {
    let id: Int
    let title: String
    let album: String
    let duration: Int

    var durationText: String {
        String(format: "%02d:%02d", duration / 60, duration % 60)
    }
}

#Preview("DataTable") {
    let rows = [
        DataTablePreviewRow(id: 1, title: "最佳损友", album: "Life Continues...", duration: 233),
        DataTablePreviewRow(id: 2, title: "富士山下", album: "What's Going On...?", duration: 258),
        DataTablePreviewRow(id: 3, title: "孤独患者", album: "?", duration: 271)
    ]

    let columns: [DataTableColumn<DataTablePreviewRow>] = [
        DataTableColumn(
            id: "index",
            title: "#",
            width: .fixed(50),
            alignment: .center,
            content: { _, context in
                Text(String(format: "%02d", context.rowNumber))
                    .font(.font12)
                    .foregroundStyle(Color.textSecondary)
            }
        ),

        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: 120),
            sortComparator: { lhs, rhs in
                lhs.title.localizedStandardCompare(rhs.title)
            },
            content: { row, _ in
                Text(row.title)
                    .font(.font14.weight(.medium))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
            }
        ),

        DataTableColumn(
            id: "album",
            title: "专辑",
            width: .fixed(180),
            sortComparator: { lhs, rhs in
                lhs.album.localizedStandardCompare(rhs.album)
            },
            content: { row, _ in
                Text(row.album)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        ),

        DataTableColumn(
            id: "actions",
            title: "",
            width: .fixed(44),
            alignment: .center,
            visibility: .rowHoverOnly,
            content: { _, _ in
                Image(systemName: "ellipsis")
                    .font(.font18)
                    .foregroundStyle(Color.textSecondary)
            }
        ),

        DataTableColumn(
            id: "duration",
            title: "时长",
            width: .fixed(64),
            alignment: .trailing,
            sortComparator: { lhs, rhs in
                lhs.duration.compare(rhs.duration)
            },
            content: { row, _ in
                Text(row.durationText)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
                    .monospacedDigit()
            }
        )
    ]

    DataTable(rows: rows, columns: columns)
        .padding(20)
        .frame(width: 600)
        .background(Color.surfacePrimary)
}

//
//  ProgramTableColumns.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/14.
//

import SwiftUI

enum ProgramTableColumns {
    static func title(
        onAction: @escaping (MusicTableRowAction, Program) -> Void
    ) -> DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "title",
            title: "标题",
            width: .flexible(min: Layout.titleMinWidth),
            alignment: .leading,
            content: { row, context in
                ProgramTableTitleCell(
                    row: row,
                    rowState: row.rowState(in: context),
                    onAction: {
                        onAction($0, row.program)
                    }
                )
            }
        )
    }

    static var updateDate: DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "updateDate",
            title: "更新日期",
            width: .fixed(Layout.updateDateWidth),
            content: { row, _ in
                valueText(row.updateDateText)
            }
        )
    }

    static var playCount: DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "playedCount",
            title: "播放量",
            width: .fixed(Layout.playCountWidth),
            content: { row, _ in
                valueText(row.playCount)
            }
        )
    }

    static var duration: DataTableColumn<ProgramTableRow> {
        DataTableColumn(
            id: "duration",
            title: "时长",
            width: .fixed(Layout.durationWidth),
            content: { row, _ in
                valueText(row.durationText)
                    .monospacedDigit()
            }
        )
    }
}

private extension ProgramTableColumns {
    static func valueText(_ text: String) -> some View {
        Text(text)
            .font(.font13)
            .foregroundStyle(Color.textTertiary)
            .lineLimit(1)
    }

    enum Layout {
        static let titleMinWidth: CGFloat = 160
        static let updateDateWidth: CGFloat = 110
        static let playCountWidth: CGFloat = 90
        static let durationWidth: CGFloat = 80
    }
}

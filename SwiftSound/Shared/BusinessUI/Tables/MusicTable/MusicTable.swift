//
//  MusicTable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

enum MusicTablePlaybackAction {
    case play
    case pause
}

protocol MusicTableRow: Identifiable {
    var playbackStatus: MusicTablePlaybackStatus { get }
    var rankingInfo: (any RankingInfoProviding)? { get }
}

extension MusicTableRow {
    var rankingInfo: (any RankingInfoProviding)? { nil }
}

struct MusicTable<Row: MusicTableRow>: View where Row.ID: Hashable {
    let rows: [Row]
    let columns: [DataTableColumn<Row>]
    let style: DataTableStyle
    let onPlaybackAction: (MusicTablePlaybackAction, Row) -> Void

    init(
        rows: [Row],
        columns: [DataTableColumn<Row>],
        style: DataTableStyle = .plain,
        onPlaybackAction: @escaping (MusicTablePlaybackAction, Row) -> Void
    ) {
        self.rows = rows
        self.columns = columns
        self.style = style
        self.onPlaybackAction = onPlaybackAction
    }

    var body: some View {
        DataTable(
            rows: rows,
            columns: [indexColumn] + columns,
            style: style,
            isRowHighlighted: { $0.playbackStatus.isCurrent }
        )
    }
}

private extension MusicTable {
    var indexColumn: DataTableColumn<Row> {
        DataTableColumn(
            id: "index",
            title: "#",
            width: .fixed(Layout.indexWidth),
            alignment: .center,
            content: { row, context in
                MusicTableIndexCell(
                    index: context.rowNumber,
                    rowState: row.rowState(in: context),
                    rankingInfo: row.rankingInfo
                ) {
                    let action: MusicTablePlaybackAction = row.playbackStatus.isPlaying ? .pause : .play
                    onPlaybackAction(action, row)
                }
            }
        )
    }
}

private enum Layout {
    static let indexWidth: CGFloat = 54
}

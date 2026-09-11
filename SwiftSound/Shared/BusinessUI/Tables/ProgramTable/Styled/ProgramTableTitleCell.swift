//
//  ProgramTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import SwiftUI

struct ProgramTableTitleCell: View {
    let row: ProgramTableRow
    let rowState: MusicTableRowState
    let onAction: (MusicTableRowAction) -> Void

    var body: some View {
        MusicTableTitleCell(
            imageURL: row.imageURL,
            title: row.title,
            rowState: rowState
        ) {
            MusicTableRouteLink(
                title: row.radio.name,
                route: .radio(id: row.radio.id)
            )
        } actions: {
            MusicTableActionView(
                items: [.download, .comment, .more],
                onAction: onAction
            )
        }
    }
}

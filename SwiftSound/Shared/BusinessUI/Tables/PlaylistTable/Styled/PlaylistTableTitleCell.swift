//
//  PlaylistTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

struct PlaylistTableTitleCell: View {
    let row: PlaylistTableRow
    let rowState: MusicTableRowState
    let onAction: (PlaylistTableAction) -> Void

    var body: some View {
        MusicTableTitleCell(
            imageURL: row.imageURL,
            title: row.title,
            rowState: rowState
        ) {
            MusicTableActionView(
                items: PlaylistTableAction.items,
                onAction: onAction
            )
        }
        .routeLink(to: .playlist(id: row.id))
    }
}

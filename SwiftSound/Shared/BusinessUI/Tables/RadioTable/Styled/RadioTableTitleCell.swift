//
//  RadioTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/10.
//

import SwiftUI

struct RadioTableTitleCell: View {
    let row: RadioTableRow
    let rowState: MusicTableRowState
    let onAction: (MusicTableRowAction) -> Void

    var body: some View {
        MusicTableTitleCell(
            imageURL: row.imageURL,
            title: row.title,
            rowState: rowState
        ) {
            if let subtitle = row.subtitle {
                Text(subtitle)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)
            } else {
                EmptyView()
            }
        } actions: {
            MusicTableActionView(
                items: [.subscribe, .more],
                onAction: onAction
            )
        }
        .routeLink(to: .radio(id: row.id))
    }
}

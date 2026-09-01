//
//  SongTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import SwiftUI

struct SongTableTitleCell: View {
    let row: SongTableRow
    let rowState: MusicTableRowState
    let onAction: (SongTableAction) -> Void

    var body: some View {
        MusicTableTitleCell(
            imageURL: row.imageURL,
            title: row.title,
            titleSuffix: row.titleSuffix,
            rowState: rowState
        ) {
            HStack(spacing: Layout.linkSpacing) {
                SongTableBadges(row: row)
                artistLinks
            }
        } actions: {
            MusicTableActionView(
                items: SongTableAction.items,
                onAction: onAction
            )
        }
    }

    private var artistLinks: some View {
        SeparatedText(
            items: row.song.artists.map {
                SeparatedText.Item(
                    title: $0.name,
                    route: .artist(id: $0.id)
                )
            },
            foregroundStyle: rowState.subtitleColor,
            hoverForegroundStyle: rowState.isCurrent ? rowState.subtitleColor : Color.textPrimary
        )
    }
}

private extension SongTableTitleCell {
    enum Layout {
        static let linkSpacing: CGFloat = 6
    }
}

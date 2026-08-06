//
//  SongTableStyle.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/6.
//

struct SongTableStyle {
    let dataTableStyle: DataTableStyle
    let showsAlbumColumn: Bool
    let showsPopularityColumn: Bool

    static let `default` = SongTableStyle(
        dataTableStyle: .plain,
        showsAlbumColumn: true,
        showsPopularityColumn: false
    )

    static let albumSongs = SongTableStyle(
        dataTableStyle: .plain,
        showsAlbumColumn: false,
        showsPopularityColumn: true
    )
}

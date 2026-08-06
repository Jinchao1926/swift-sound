//
//  AlbumSongsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/30.
//

import SwiftUI

struct AlbumSongsPage: View {
    let songs: [Song]

    var body: some View {
        SongTable(songs: songs, style: .albumSongs)
    }
}

#Preview {
    AlbumSongsPage(songs: Array.songsPreview)
}

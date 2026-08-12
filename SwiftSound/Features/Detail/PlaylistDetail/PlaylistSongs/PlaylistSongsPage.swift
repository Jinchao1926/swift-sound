//
//  PlaylistSongsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import SwiftUI

struct PlaylistSongsPage: View {
    let songs: [Song]

    var body: some View {
        SongTable(songs: songs)
    }
}

#Preview {
    PlaylistSongsPage(songs: Array.songsPreview)
        .environmentObject(PlayerStore())
}

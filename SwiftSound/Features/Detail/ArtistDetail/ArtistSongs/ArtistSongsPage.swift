//
//  ArtistSongsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/24.
//

import SwiftUI

struct ArtistSongsPage: View {
    let state: Loadable<[Song]>
    let load: () async -> Void

    var body: some View {
        PlaceholderPage(title: "ArtistSongs")
    }
}

#Preview {
    ArtistSongsPage(state: .loaded(Array.songsPreview), load: {})
}

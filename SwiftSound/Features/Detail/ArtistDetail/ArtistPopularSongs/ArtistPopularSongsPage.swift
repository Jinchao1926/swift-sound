//
//  ArtistPopularSongsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/24.
//

import SwiftUI

struct ArtistPopularSongsPage: View {
    let id: Int
    let state: Loadable<[Song]>
    let load: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RouteTitleLink(
                "热门歌曲",
                route: .artistSongs(id: id),
                variant: .large
            )

            if let songs = state.value {
                SongTable(songs: songs)
                    .padding(.top, Layout.tableTopPadding)
            }
        }
        .padding(.bottom, Layout.bottomInset)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await load()
        }
    }
}

private extension ArtistPopularSongsPage {
    enum Layout {
        static let bottomInset: CGFloat = 20
        static let tableTopPadding: CGFloat = 12
    }
}

#Preview {
    ArtistPopularSongsPage(
        id: Artist.preview.id,
        state: .loaded(Array.songsPreview),
        load: {}
    )
    .environmentObject(PlayerStore())
    .padding(40)
    .frame(width: 1300)
}

//
//  FeaturedPlaylistEntry.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import SwiftUI

struct FeaturedPlaylistEntry: View {
    let playlist: Playlist?

    var body: some View {
        VStack {
            Text("精品歌单")
        }
        .frame(width: Layout.width, height: Layout.height)
    }
}

private extension FeaturedPlaylistEntry {
    enum Layout {
        static let width: CGFloat = 116
        static let height: CGFloat = 116
    }
}

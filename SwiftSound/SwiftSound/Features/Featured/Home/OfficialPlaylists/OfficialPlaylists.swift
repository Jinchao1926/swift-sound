//
//  Playlists.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct OfficialPlaylists: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RouteTitleLink("官方歌单", route: FeaturedRoute.playlistSquare)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 40)
        .padding(.top, 20)
    }
}

#Preview {
    OfficialPlaylists()
        .padding()
        .environmentObject(AppRouter())
}

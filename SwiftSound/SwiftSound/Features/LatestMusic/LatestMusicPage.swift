//
//  LatestMusicPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct LatestMusicPage: View {
    let route: LatestMusicRoute

    var body: some View {
        VStack(spacing: 10) {
            RouteTabView(selectedRoute: route)
            content
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .newTrack:
            NewTrackPage()
        case .newAlbum:
            NewAlbumPage()
        }
    }
}

#Preview {
    LatestMusicPage(route: .newTrack)
        .environmentObject(AppRouter())
}

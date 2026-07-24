//
//  ArtistDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import SwiftUI

struct ArtistDetailPage: View {
    let id: Int
    let route: ArtistRoute

    var body: some View {
        VStack(spacing: 10) {
            Text("歌手详情: \(id)")
            RouteTabView(
                selectedRoute: route,
                destinationRoute: { .artist(id: id, secondary: $0) }
            )
            content
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    var content: some View {
        switch route {
        case .songs:
            ArtistSongsPage()
        case .albums:
            ArtistAlbumsPage()
        case .mvs:
            ArtistMVsPage()
        case .profile:
            ArtistProfilePage()
        case .similarArtists:
            SimilarArtistsPage()
        case .performances:
            ArtistPerformancesPage()
        }
    }
}

#Preview {
    ArtistDetailPage(id: Artist.preview.id, route: .songs)
}

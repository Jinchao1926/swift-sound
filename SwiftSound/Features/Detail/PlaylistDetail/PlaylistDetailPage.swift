//
//  PlaylistDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import SwiftUI

struct PlaylistDetailPage: View {
    let id: Int
    let route: PlaylistRoute

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.spacing) {
                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: { .playlist(id: id, secondary: $0) }
                )

                content
            }
            .padding(.horizontal, Layout.horizontalPadding)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .songs:
            PlaylistSongsPage()
        case .comments:
            PlaylistCommentsPage()
        case .subscribers:
            PlaylistSubscribersPage()
        }
    }
}

private extension PlaylistDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalPadding: CGFloat = 40
    }
}

#Preview {
    PlaylistDetailPage(id: Playlist.preview.id, route: .songs)
}

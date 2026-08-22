//
//  UserDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import SwiftUI

struct UserDetailPage: View {
    let id: Int
    let route: UserRoute

    var body: some View {
        VStack {
            Text("UserDetailPage: \(id)")
            content(for: route)
        }
    }

    @ViewBuilder
    private func content(for route: UserRoute) -> some View {
        switch route {
        case .playlists:
            UserPlaylistsPage()
        case .notes:
            UserNotesPage()
        case .podcasts:
            UserPodcastsPage()
        }
    }
}

#Preview {
    UserDetailPage(id: 123, route: .playlists)
}

//
//  AlbumDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/30.
//

import SwiftUI

struct AlbumDetailPage: View {
    let id: Int
    let route: AlbumRoute

    var body: some View {
        VStack {
            Text("UserDetailPage: \(id)")
            content
        }
    }

    @ViewBuilder
    var content: some View {
        switch route {
        case .songs:
            AlbumSongsPage()
        case .comments:
            AlbumCommentsPage()
        case .profile:
            AlbumProfilePage()
        }
    }
}

#Preview {
    AlbumDetailPage(id: Album.preview.id, route: .songs)
}

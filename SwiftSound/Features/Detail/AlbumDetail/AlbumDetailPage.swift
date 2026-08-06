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

    @StateObject private var viewModel: AlbumDetailViewModel

    init(id: Int, route: AlbumRoute) {
        self.id = id
        self.route = route
        self._viewModel = StateObject(wrappedValue: AlbumDetailViewModel(id: id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.spacing) {
                if let album = viewModel.state.album {
                    AlbumDetailHeader(album: album)
                }

                content
            }
        }
        .task {
            await viewModel.load()
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

private extension AlbumDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
    }
}

#Preview {
    AlbumDetailPage(id: Album.preview.id, route: .songs)
}

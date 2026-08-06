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
                    AlbumDetailHeader(
                        album: album,
                        subCount: viewModel.dynamicState.value?.subCount
                    )
                    .padding(.horizontal, Layout.horizontalPadding)
                }

                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: { .album(id: id, secondary: $0) }
                )
                content
                    .padding(.horizontal, Layout.horizontalPadding)
            }
        }
        .task {
            await viewModel.loadAlbum()
        }
    }

    @ViewBuilder
    var content: some View {
        switch route {
        case .songs:
            AlbumSongsPage(songs: viewModel.state.songs)
        case .comments:
            AlbumCommentsPage()
        case .profile:
            AlbumProfilePage(description: viewModel.state.album?.description)
        }
    }
}

private extension AlbumDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalPadding: CGFloat = 40
    }
}

#Preview {
    AlbumDetailPage(id: Album.preview.id, route: .songs)
}

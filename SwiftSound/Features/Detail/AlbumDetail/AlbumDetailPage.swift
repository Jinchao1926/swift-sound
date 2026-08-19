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
    @EnvironmentObject private var playerStore: PlayerStore

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
                        subCount: viewModel.dynamicState.value?.subCount,
                        onPlayAll: playAllSongs
                    )
                }

                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: {
                        .album(id: id, secondary: $0)
                    },
                    badgeText: tabBadgeText,
                    trailingSlot: {
                        tabTrailingSlot
                    }
                )

                content
            }
            .padding(.horizontal, Layout.horizontalInset)
        }
        .task {
            await viewModel.loadAlbum()
        }
    }

    @ViewBuilder
    private var tabTrailingSlot: some View {
        if route == .songs {
            SearchBar(text: $viewModel.songSearchText)
        }
    }

    @ViewBuilder
    var content: some View {
        switch route {
        case .songs:
            AlbumSongsPage(songs: viewModel.filteredSongs)
        case .comments:
            AlbumCommentsPage()
        case .profile:
            AlbumProfilePage(description: viewModel.state.album?.description)
        }
    }

    private func tabBadgeText(for route: AlbumRoute) -> String? {
        switch route {
        case .songs:
            return viewModel.state.songs.count.formatted()
        case .comments:
            return viewModel.dynamicState.value?.commentCount.formatted()
        default:
            return nil
        }
    }
}

// MARK: - Actions
private extension AlbumDetailPage {
    func playAllSongs() {
        guard !viewModel.state.songs.isEmpty else { return }
        playerStore.send(.playQueue(viewModel.state.songs, startIndex: 0))
    }
}

private extension AlbumDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    AlbumDetailPage(id: Album.preview.id, route: .songs)
        .environmentObject(AppRouter())
        .environmentObject(PlayerStore())
}

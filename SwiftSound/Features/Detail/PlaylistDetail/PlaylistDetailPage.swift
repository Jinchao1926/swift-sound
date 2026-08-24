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

    @StateObject private var viewModel: PlaylistDetailViewModel
    @EnvironmentObject private var playerStore: PlayerStore

    init(id: Int, route: PlaylistRoute) {
        self.id = id
        self.route = route
        self._viewModel = StateObject(wrappedValue: PlaylistDetailViewModel(id: id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.spacing) {
                if let playlist = viewModel.state.value {
                    PlaylistDetailHeader(
                        playlist: playlist,
                        onPlayAll: playAllSongs
                    )
                }

                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: {
                        .playlist(id: id, secondary: $0)
                    },
                    badgeText: tabBadgeText,
                    trailingSlot: {
                        tabTrailingSlot(for: route)
                    }
                )

                content(for: route)
            }
            .padding(.horizontal, Layout.horizontalInset)
        }
        .scrollIndicatorOverlay()
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private func content(for route: PlaylistRoute) -> some View {
        switch route {
        case .songs:
            PlaylistSongsPage(songs: viewModel.filteredSongs)
        case .comments:
            PlaylistCommentsPage()
        case .subscribers:
            PlaylistSubscribersPage(
                state: viewModel.subscriberState,
                load: viewModel.loadSubscribers,
                loadMore: viewModel.loadMoreSubscribers
            )
        }
    }

    @ViewBuilder
    private func tabTrailingSlot(for route: PlaylistRoute) -> some View {
        if route == .songs {
            SearchBar(text: $viewModel.songSearchText)
        }
    }

    private func tabBadgeText(for route: PlaylistRoute) -> String? {
        switch route {
        case .songs:
            return viewModel.state.value?.tracks?.count.formatted()
        case .comments:
            return viewModel.state.value?.commentCount?.formattedCount()
        case .subscribers:
            return viewModel.state.value?.subscribedCount.formattedCount()
        }
    }
}

// MARK: - Actions
private extension PlaylistDetailPage {
    func playAllSongs() {
        guard let songs = viewModel.state.value?.tracks, !songs.isEmpty else { return }

        playerStore.send(.playQueue(songs, startIndex: 0))
    }
}

private extension PlaylistDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    PlaylistDetailPage(id: Playlist.preview.id, route: .songs)
}

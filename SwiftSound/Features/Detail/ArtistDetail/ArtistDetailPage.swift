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

    @StateObject private var viewModel: ArtistDetailViewModel
    @EnvironmentObject private var playerStore: PlayerStore

    init(id: Int, route: ArtistRoute) {
        self.id = id
        self.route = route
        self._viewModel = StateObject(wrappedValue: ArtistDetailViewModel(id: id))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.spacing) {
                ArtistDetailHeader(
                    detail: viewModel.state.value,
                    onPlayAll: playAllSongs
                )

                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: { .artist(id: id, secondary: $0) },
                    badgeText: tabBadgeText
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
    private func content(for route: ArtistRoute) -> some View {
        switch route {
        case .songs:
            ArtistPopularSongsPage(
                id: id,
                state: viewModel.songsState,
                load: viewModel.loadPopularSongs
            )
        case .albums:
            ArtistAlbumsPage(
                state: viewModel.albumState,
                load: viewModel.loadAlbums,
                loadMore: viewModel.loadMoreAlbums,
                onPlayAlbum: playAlbum
            )
        case .mvs:
            ArtistMVsPage(
                state: viewModel.mvState,
                load: viewModel.loadMVs,
                loadMore: viewModel.loadMoreMVs
            )
        case .profile:
            ArtistProfilePage(
                name: viewModel.state.artist?.name,
                state: viewModel.profileState,
                load: viewModel.loadProfile
            )
        case .similarArtists:
            SimilarArtistsPage()
        }
    }

    private func playAlbum(_ albumID: Album.ID) {
        playerStore.send(.play(.source(.album(id: albumID))))
    }

    private func playAllSongs() {
        guard let songs = viewModel.songsState.value, !songs.isEmpty else { return }
        playerStore.send(.play(.songs(songs, startIndex: 0)))
    }

    private func tabBadgeText(for route: ArtistRoute) -> String? {
        guard let artist = viewModel.state.artist else { return nil }

        switch route {
        case .albums:
            return artist.albumSize?.formatted()
        case .mvs:
            return artist.mvSize?.formatted()
        default:
            return nil
        }
    }
}

private extension ArtistDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    ArtistDetailPage(id: Artist.preview.id, route: .songs)
        .frame(width: 800, height: 600)
        .environmentObject(AppRouter())
        .environmentObject(PlayerStore())
}

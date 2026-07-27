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

    init(id: Int, route: ArtistRoute) {
        self.id = id
        self.route = route
        self._viewModel = StateObject(wrappedValue: ArtistDetailViewModel(id: id))
    }

    var body: some View {
        VStack(spacing: 10) {
            header
            RouteTabView(
                selectedRoute: route,
                destinationRoute: { .artist(id: id, secondary: $0) }
            )
            content
            Spacer(minLength: 0)
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    var header: some View {
        if let artist = viewModel.state.artist {
            HStack(spacing: 25) {
                RemoteImage(url: artist.avatarURL)
                    .frame(width: 170, height: 170)
                    .rounded(radius: 170 / 2)

                VStack(alignment: .leading, spacing: 0) {
                    Text(artist.name)
                        .font(.font18)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)

                    HStack(spacing: 20) {
                        AliasText(alias: artist.aliases)

                        if let user = viewModel.state.user {
                            RouteLink(route: .user(id: user.userId)) {
                                Text("个人页 >")
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)

                    HStack(spacing: 10) {
                        ActionButton(
                            "播放全部",
                            systemName: "play.fill",
                            variant: .primary
                        ) {}

                        ActionButton(
                            "关注",
                            systemName: "plus"
                        ) {}
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 40)
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

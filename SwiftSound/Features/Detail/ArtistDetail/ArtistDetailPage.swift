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
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.spacing) {
                header
                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: { .artist(id: id, secondary: $0) }
                )
                content
            }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    var header: some View {
        if let artist = viewModel.state.artist {
            HStack(spacing: Layout.headerSpacing) {
                RemoteImage(url: artist.avatarURL)
                    .frame(width: Layout.avatarSize, height: Layout.avatarSize)
                    .rounded(radius: Layout.avatarSize / 2)

                VStack(alignment: .leading, spacing: 0) {
                    Text(artist.name)
                        .font(.font18)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)

                    HStack(spacing: Layout.metadataSpacing) {
                        AliasText(alias: artist.aliases)

                        if let user = viewModel.state.user {
                            RouteLink(route: .user(id: user.userId)) {
                                Text("个人页 >")
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                    .padding(.top, Layout.metadataTopPadding)
                    .padding(.bottom, Layout.metadataBottomPadding)

                    HStack(spacing: Layout.actionSpacing) {
                        ActionButton(
                            "播放全部",
                            systemName: "play.fill",
                            variant: .primary
                        ) {}

                        ActionButton("关注", systemName: "plus" ) {}
                    }
                }

                Spacer()
            }
            .padding(.horizontal, Layout.horizontalPadding)
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
            ArtistProfilePage(
                name: viewModel.state.artist?.name,
                state: viewModel.profileState,
                load: viewModel.loadProfile
            )
        case .similarArtists:
            SimilarArtistsPage()
        case .performances:
            ArtistPerformancesPage()
        }
    }
}

private extension ArtistDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let headerSpacing: CGFloat = 25
        static let avatarSize: CGFloat = 170
        static let horizontalPadding: CGFloat = 40
        static let metadataSpacing: CGFloat = 20
        static let metadataTopPadding: CGFloat = 12
        static let metadataBottomPadding: CGFloat = 16
        static let actionSpacing: CGFloat = 10
    }
}

#Preview {
    ArtistDetailPage(id: Artist.preview.id, route: .songs)
}

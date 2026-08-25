//
//  UserPlaylistsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import SwiftUI

struct UserPlaylistsPage: View {
    @ObservedObject var viewModel: UserDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            UserPlaylistSection(
                title: "Ta创建的歌单",
                collection: viewModel.createdPlaylists,
                onPageChange: { page in
                    Task { await viewModel.loadCreated(page: page) }
                }
            )

            UserPlaylistSection(
                title: "Ta收藏的歌单",
                collection: viewModel.favoritePlaylists,
                onPageChange: { page in
                    Task { await viewModel.loadFavorite(page: page) }
                }
            )
        }
        .padding(.top, Layout.contentTopInset)
        .padding(.bottom, Layout.contentBottomInset)
    }
}

private extension UserPlaylistsPage {
    enum Layout {
        static let contentTopInset: CGFloat = 10
        static let contentBottomInset: CGFloat = 40
        static let sectionSpacing: CGFloat = 75
    }
}

#Preview {
    ScrollView {
        UserPlaylistsPage(viewModel: UserDetailViewModel(id: User.official.userId))
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding()
}

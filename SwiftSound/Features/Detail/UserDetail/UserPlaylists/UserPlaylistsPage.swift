//
//  UserPlaylistsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import SwiftUI

struct UserPlaylistsPage: View {
    @ObservedObject var viewModel: UserDetailViewModel
    let onScrollToTop: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.tabContentSpacing) {
            UserPlaylistTabView(
                selectedTab: viewModel.selectedTab,
                onSelect: select
            )

            UserPlaylistSection(
                collection: viewModel.selectedPlaylists,
                onPageChange: load
            )
        }
        .padding(.top, Layout.contentTopInset)
        .padding(.bottom, Layout.contentBottomInset)
    }
}

private extension UserPlaylistsPage {
    func select(_ tab: PlaylistTab) {
        Task {
            await viewModel.selectPlaylistTab(tab)
        }
    }

    func load(page: Int) {
        onScrollToTop()
        Task {
            await viewModel.loadPlaylistPage(page)
        }
    }

    enum Layout {
        static let contentTopInset: CGFloat = 20
        static let contentBottomInset: CGFloat = 40
        static let tabContentSpacing: CGFloat = 24
    }
}

#Preview {
    ScrollView {
        UserPlaylistsPage(
            viewModel: UserDetailViewModel(id: User.official.userId),
            onScrollToTop: {}
        )
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding()
}

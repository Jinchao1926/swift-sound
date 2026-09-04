//
//  ArtistSongsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import SwiftUI

struct ArtistSongsPage: View {
    let id: Int
    @StateObject private var viewModel: ArtistSongsViewModel

    init(id: Int) {
        self.id = id
        self._viewModel = StateObject(wrappedValue: ArtistSongsViewModel(id: id))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                Text("全部歌曲")
                    .font(.font24)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                HStack(spacing: Layout.actionSpacing) {
                    MusicActionButtons.playAll {}
                    MusicActionButtons.download(icon: .squareAndArrowDown) {}
                    MusicActionButtons.more {}
                }
                .padding(.top, Layout.actionTopInset)
                .padding(.bottom, Layout.actionBottomInset)

                SongTable(songs: viewModel.state.items)
                    .loadable(state: viewModel.state, retry: viewModel.load)

                InfiniteScrollFooter(state: viewModel.state) {
                    await viewModel.loadMore()
                }
            }
            .padding(.horizontal, Layout.horizontalInset)
            .task {
                await viewModel.load()
            }
        }
    }
}

private enum Layout {
    static let horizontalInset: CGFloat = 40
    static let actionTopInset: CGFloat = 25
    static let actionBottomInset: CGFloat = 15
    static let actionSpacing: CGFloat = 10
}

#Preview {
    ArtistSongsPage(id: Artist.preview.id)
        .environmentObject(PlayerStore())
}

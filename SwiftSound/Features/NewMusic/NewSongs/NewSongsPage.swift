//
//  NewSongsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct NewSongsPage: View {
    @StateObject private var viewModel = NewSongsViewModel()
    @EnvironmentObject private var playerStore: PlayerStore

    var body: some View {
        VStack(spacing: Layout.spacing) {
            HStack(spacing: Layout.filterSpacing) {
                ForEach(TopSongsType.allCases) { type in
                    SelectableCapsule(
                        type.title,
                        isSelected: viewModel.selectedType == type,
                        width: .fitContent,
                        contentPadding: Layout.capsulePadding
                    ) {
                        viewModel.selectedType = type
                    }
                }
                Spacer()
                MusicActionButtons.playAll {
                    playAllSongs()
                }
                MusicActionButtons.favorite("收藏全部") {}
            }

            SongTable(songs: viewModel.state.items, style: .newSongs)
                .loadingPlaceholder(viewModel.state.isLoading)
        }
        .padding(.horizontal, Layout.horizontalInset)
        .task(id: viewModel.selectedType) {
            await viewModel.load()
        }
    }
}

private extension NewSongsPage {
    func playAllSongs() {
        guard !viewModel.state.items.isEmpty else { return }
        playerStore.send(.play(.songs(viewModel.state.items, startIndex: 0)))
    }
}

private extension NewSongsPage {
    enum Layout {
        static let spacing: CGFloat = 20
        static let filterSpacing: CGFloat = 10
        static let capsulePadding: CGFloat = 14
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    ScrollView {
        NewSongsPage()
    }
    .frame(width: 800, height: 600)
    .padding()
    .environmentObject(PlayerStore())
}

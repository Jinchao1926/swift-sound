//
//  FeaturedPlaylistPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import SwiftUI
import Combine

struct FeaturedPlaylistPage: View {
    @StateObject private var viewModel: FeaturedPlaylistViewModel
    @State private var isPickerPresented = false

    init(initialCategory: String) {
        _viewModel = StateObject(
            wrappedValue: FeaturedPlaylistViewModel(initialCategory: initialCategory)
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Layout.spacing) {
                HStack {
                    Text("精品歌单")
                        .font(.font26)
                        .foregroundStyle(Color(hex: 0x525A6D))
                    Spacer()
                    moreCategoryButton
                }

                LazyVGrid(
                    columns: Layout.gridColumns,
                    alignment: .leading,
                    spacing: Layout.gridSpacing
                ) {
                    Section {
                        ForEach(viewModel.playlistState.items) {
                            FeaturedPlaylistCard(playlist: $0) {
                                // ...
                            }
                            .routeLink(to: .playlist(id: $0.id))
                        }
                    } footer: {
                        InfiniteScrollFooter(state: viewModel.playlistState) {
                            await viewModel.loadMorePlaylists()
                        }
                    }
                }
                .loadingPlaceholder(viewModel.playlistState.isInitialLoading)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
        }
        .task {
            await viewModel.loadFeaturedTags()
        }
        .task(id: viewModel.selectedTag) {
            await viewModel.loadPlaylists()
        }
    }
}

private extension FeaturedPlaylistPage {
    var moreCategoryButton: some View {
        SelectableCapsule(
            "更多分类",
            isSelected: false,
            width: .fitContent,
            contentPadding: Layout.morePadding,
            accessorySystemImage: isPickerPresented ? "chevron.up" : "chevron.down"
        ) {
            isPickerPresented.toggle()
        }
        .popover(isPresented: $isPickerPresented, arrowEdge: .bottom) {
            FeaturedPlaylistTagsPicker(
                tags: viewModel.tagState.items,
                selectedTag: viewModel.selectedTag,
                onSelected: {
                    viewModel.selectedTag = $0
                    isPickerPresented = false
                }
            )
        }
    }
}

private extension FeaturedPlaylistPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let verticalPadding: CGFloat = 30
        static let horizontalPadding: CGFloat = 40
        static let morePadding: CGFloat = 16

        static let minimumCardWidth: CGFloat = 178
        static let gridSpacing: CGFloat = 20

        static let gridColumns: [GridItem] = [
            GridItem(.adaptive(minimum: minimumCardWidth), spacing: gridSpacing, alignment: .top)
        ]
    }
}

#Preview {
    FeaturedPlaylistPage(initialCategory: "华语")
}

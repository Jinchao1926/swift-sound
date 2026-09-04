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
        ScrollView {
            VStack(spacing: Layout.spacing) {
                HStack {
                    Text("精品歌单")
                        .font(.font26)
                        .foregroundStyle(Color(hex: 0x525A6D))
                    Spacer()
                    moreCategoryButton
                }

                PaginatedGridView(
                    state: viewModel.playlistState,
                    minItemWidth: Layout.minItemWidth,
                    columnSpacing: Layout.columnSpacing,
                    rowSpacing: Layout.rowSpacing,
                    loadMore: viewModel.loadMorePlaylists
                ) {
                    ForEach(viewModel.playlistState.items) {
                        FeaturedPlaylistCard(playlist: $0) {
                            // ...
                        }
                        .routeLink(to: .playlist(id: $0.id))
                    }
                }
                .loadingPlaceholder(viewModel.playlistState.isInitialLoading)
            }
            .padding(.horizontal, Layout.horizontalInset)
            .padding(.vertical, Layout.verticalInset)
        }
        .scrollIndicatorOverlay()
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
            contentPadding: Layout.moreInset,
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
        static let verticalInset: CGFloat = 30
        static let horizontalInset: CGFloat = 40
        static let moreInset: CGFloat = 16

        static let minItemWidth: CGFloat = 178
        static let columnSpacing: CGFloat = 20
        static let rowSpacing: CGFloat = 20
    }
}

#Preview {
    FeaturedPlaylistPage(initialCategory: "华语")
}

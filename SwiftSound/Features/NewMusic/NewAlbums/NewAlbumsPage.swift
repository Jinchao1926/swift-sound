//
//  NewAlbumPages.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct NewAlbumsPage: View {
    @StateObject private var viewModel = NewAlbumsViewModel()

    var body: some View {
        VStack(spacing: Layout.spacing) {
            filterHeader

            VStack(alignment: .leading, spacing: Layout.spacing) {
                if let weekData = viewModel.state.value?.weekData {
                    albumGridTitle("本周新碟")
                    albumGrid(for: weekData)
                }

                if let monthData = viewModel.state.value?.monthData {
                    albumGridTitle(Date.now.formattedChineseYearMonth())
                    albumGrid(for: monthData)
                }
            }
            .loadingPlaceholder(viewModel.state.isLoading)
        }
        .padding(.horizontal, Layout.horizontalInset)
        .task(id: viewModel.selection) {
            await viewModel.load()
        }
    }
}

private extension NewAlbumsPage {
    var filterHeader: some View {
        HStack(spacing: Layout.filterSpacing) {
            ForEach(TopAlbumsArea.allCases) { area in
                SelectableCapsule(
                    area.title,
                    isSelected: viewModel.selection.area == area,
                    width: .fitContent,
                    contentPadding: Layout.capsulePadding
                ) {
                    viewModel.updateSelection(area: area)
                }
            }

            Spacer()

            ForEach(TopAlbumsType.allCases) { type in
                Button {
                    viewModel.updateSelection(type: type)
                } label: {
                    Text(type.title)
                        .font(.font15.weight(.semibold))
                        .foregroundStyle(viewModel.selection.type == type ? Color.accentPrimary : Color.textPrimary)
                }
                .buttonStyle(.plain)
                .pointerStyle(.link)

                if type != TopAlbumsType.allCases.last {
                    Rectangle()
                        .fill(Color.divider)
                        .frame(width: 1, height: 8)
                }
            }
        }
    }

    func albumGridTitle(_ title: String) -> some View {
        Text(title)
            .font(.font18)
            .fontWeight(.bold)
            .foregroundStyle(Color.textPrimary)
    }

    func albumGrid(for albums: [Album]) -> some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: Layout.minItemWidth),
                    spacing: Layout.columnSpacing,
                    alignment: .top
                )
            ],
            alignment: .leading,
            spacing: Layout.rowSpacing
        ) {
            ForEach(albums) { album in
                AlbumCard(album: album) {
                    // ..
                }
                .routeLink(to: .album(id: album.id))
            }
        }
        .padding(.bottom, Layout.spacing)
    }
}

private extension NewAlbumsPage {
    enum Layout {
        static let spacing: CGFloat = 20
        static let filterSpacing: CGFloat = 10
        static let capsulePadding: CGFloat = 14
        static let horizontalInset: CGFloat = 40

        static let minItemWidth: CGFloat = 176
        static let columnSpacing: CGFloat = 20
        static let rowSpacing: CGFloat = 20
    }
}

#Preview {
    NewAlbumsPage()
}

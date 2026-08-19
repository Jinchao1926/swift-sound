//
//  FeaturedPlaylistTagsPicker.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/19.
//

import SwiftUI

struct FeaturedPlaylistTagsPicker: View {
    let tags: [FeaturedPlaylistTag]
    let selectedTag: FeaturedPlaylistTag?
    let onSelected: (FeaturedPlaylistTag?) -> Void

    var body: some View {
        VStack(spacing: Layout.sectionSpacing) {
            Text("全部分类")
                .font(.font16)
                .foregroundStyle(Color.textPrimary)

            LazyVGrid(columns: Layout.gridColumns, alignment: .leading) {
                makeSelectableCapsule("全部分类", isSelected: selectedTag == nil) {
                    onSelected(nil)
                }

                ForEach(tags) { tag in
                    makeSelectableCapsule(tag.name, isSelected: tag == selectedTag) {
                        onSelected(tag)
                    }
                }
            }
        }
        .padding(Layout.padding)
        .frame(width: Layout.width)
        .background(Color.white)
    }

    private func makeSelectableCapsule(
        _ title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> SelectableCapsule {
        SelectableCapsule(
            title,
            isSelected: isSelected,
            font: .font13,
            width: .fixed(Layout.categoryWidth),
            defaultBackgroundColor: Color(hex: 0xF1F2F3),
            action: action
        )
    }
}

private extension FeaturedPlaylistTagsPicker {
    enum Layout {
        static let width: CGFloat = 572
        static let padding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20

        static let categoryColumnCount = 6
        static let categoryWidth: CGFloat = 80
        static let categorySpacing: CGFloat = 12

        static let gridColumns: [GridItem] = Array(
            repeating: GridItem(
                .fixed(Layout.categoryWidth),
                spacing: Layout.categorySpacing
            ),
            count: Layout.categoryColumnCount
        )
    }
}

#Preview {
    @Previewable @State var selectedTag: FeaturedPlaylistTag?

    FeaturedPlaylistTagsPicker(
        tags: .preview,
        selectedTag: selectedTag,
        onSelected: { selectedTag = $0 }
    )
    .background(Color.surfacePrimary)
}

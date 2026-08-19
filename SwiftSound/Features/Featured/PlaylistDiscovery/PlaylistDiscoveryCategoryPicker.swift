//
//  PlaylistDiscoveryCategoryPicker.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/14.
//

import SwiftUI

struct PlaylistDiscoveryCategoryPicker: View {
    let groups: [PlaylistCategoryGroup]
    let selectedCategoryID: String?
    let onSelected: (PlaylistCategory) -> Void

    @State private var selectedGroupID: Int?
    private var selectedGroup: PlaylistCategoryGroup? {
        groups.first { $0.id == selectedGroupID } ?? groups.first
    }

    // MARK: - LifeCycle
    init(
        groups: [PlaylistCategoryGroup],
        selectedCategoryID: String?,
        onSelected: @escaping (PlaylistCategory) -> Void
    ) {
        self.groups = groups
        self.selectedCategoryID = selectedCategoryID
        self.onSelected = onSelected

        let groupId = groups.first { group in
            group.subs.contains { $0.id == selectedCategoryID }
        }?.id
        _selectedGroupID = State(initialValue: groupId)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            SelectableTabView(
                items: groups,
                selectedID: selectedGroup?.id,
                title: \.name,
                onSelected: { selectedGroupID = $0.id }
            )

            if let selectedGroup {
                categoryGrid(for: selectedGroup)
            }
        }
        .padding(Layout.inset)
        .frame(width: Layout.width)
        .background(Color.white)
    }

    private func categoryGrid(for group: PlaylistCategoryGroup) -> some View {
        LazyVGrid(columns: Layout.gridColumns, alignment: .leading) {
            ForEach(group.subs) { category in
                SelectableCapsule(
                    category.name,
                    isSelected: category.id == selectedCategoryID,
                    font: .font13,
                    width: .fixed(Layout.categoryWidth),
                    defaultBackgroundColor: Color(hex: 0xF1F2F3)
                ) {
                    onSelected(category)
                }
            }
        }
    }
}

private extension PlaylistDiscoveryCategoryPicker {
    enum Layout {
        static let width: CGFloat = 572
        static let inset: CGFloat = 16
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
    PlaylistDiscoveryCategoryPicker(
        groups: .preview,
        selectedCategoryID: "摇滚",
        onSelected: { _ in }
    )
    .background(Color.surfacePrimary)
}

//
//  PlaylistDiscoveryCategoryBar.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/14.
//

import SwiftUI

struct PlaylistDiscoveryCategoryBar: View {
    let categoryGroups: [PlaylistCategoryGroup]
    @Binding var selection: PlaylistDiscoverySelection

    @State private var isPickerPresented = false

    var body: some View {
        HStack(spacing: Layout.spacing) {
            ForEach(PlaylistDiscoveryShortcut.all) { shortcut in
                SelectableCapsule(
                    shortcut.title,
                    isSelected: selection == shortcut.selection
                ) {
                    selection = shortcut.selection
                }
            }

            if !categoryGroups.isEmpty {
                moreCategoryButton
            }

            Spacer()
        }
    }

    private var moreCategoryButton: some View {
        SelectableCapsule(
            "更多分类",
            isSelected: moreCategoryIsActive,
            width: .fitContent,
            contentPadding: Layout.moreContentPadding,
            accessorySystemImage: isPickerPresented ? "chevron.up" : "chevron.down"
        ) {
            isPickerPresented.toggle()
        }
        .popover(isPresented: $isPickerPresented, arrowEdge: .bottom) {
            PlaylistDiscoveryCategoryPicker(
                groups: categoryGroups,
                selectedCategoryID: selection.categoryID,
                onSelected: {
                    selection = .category($0.id)
                    isPickerPresented = false
                }
            )
        }
    }

    private var moreCategoryIsActive: Bool {
        isPickerPresented
            || (selection.categoryID != nil && !isShortcutSelection)
    }

    private var isShortcutSelection: Bool {
        PlaylistDiscoveryShortcut.all.contains { $0.selection == selection }
    }
}

private extension PlaylistDiscoveryCategoryBar {
    enum Layout {
        static let spacing: CGFloat = 12
        static let moreContentPadding: CGFloat = 16
    }
}

#Preview {
    @Previewable @State var selection: PlaylistDiscoverySelection = .recommendation

    PlaylistDiscoveryCategoryBar(
        categoryGroups: .preview,
        selection: $selection
    )
    .padding()
    .background(Color.surfacePrimary)
}

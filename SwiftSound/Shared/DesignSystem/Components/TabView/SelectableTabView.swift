//
//  SelectableTabView.swift
//  SwiftSound
//

import SwiftUI

struct SelectableTabView<Item>: View
where Item: Identifiable, Item.ID: Hashable {
    let items: [Item]
    let selectedID: Item.ID?
    let title: (Item) -> String
    let badgeText: (Item) -> String?
    let itemSpacing: CGFloat
    let onSelected: (Item) -> Void

    init(
        items: [Item],
        selectedID: Item.ID?,
        title: @escaping (Item) -> String,
        badgeText: @escaping (Item) -> String? = { _ in nil },
        itemSpacing: CGFloat = 24,
        onSelected: @escaping (Item) -> Void
    ) {
        self.items = items
        self.selectedID = selectedID
        self.title = title
        self.badgeText = badgeText
        self.itemSpacing = itemSpacing
        self.onSelected = onSelected
    }

    var body: some View {
        HStack(spacing: itemSpacing) {
            ForEach(items) { item in
                tabItem(for: item)
            }
        }
    }

    private func tabItem(for item: Item) -> some View {
        Button {
            onSelected(item)
        } label: {
            HStack(alignment: .top, spacing: 2) {
                VStack(spacing: 3) {
                    Text(title(item))
                        .font(.font16.weight(.medium))
                        .foregroundStyle(item.id == selectedID ? Color.textPrimary : Color.textSecondary)

                    Capsule(style: .continuous)
                        .fill(item.id == selectedID ? Color.accentPrimary : Color.clear)
                        .frame(width: 18, height: 3)
                }

                if let badgeText = badgeText(item), !badgeText.isEmpty {
                    Text(badgeText)
                        .font(.font11.weight(.semibold))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .frame(height: 30)
            .contentShape(Rectangle())
            .pointerStyle(.link)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var selectedID = FeaturedRoute.featured.id

    SelectableTabView(
        items: FeaturedRoute.allCases,
        selectedID: selectedID,
        title: \.title,
        onSelected: { selectedID = $0 }
    )
    .padding()
}

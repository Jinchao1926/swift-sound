//
//  Carousel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct Carousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let configuration: CarouselConfiguration
    let content: (Item) -> Content

    @StateObject private var coordinator: CarouselCoordinator<Item.ID>
    @State private var isHovering = false

    init(
        items: [Item],
        configuration: CarouselConfiguration,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.configuration = configuration
        self.content = content
        _coordinator = StateObject(
            wrappedValue: CarouselCoordinator(
                itemIDs: items.map(\.id),
                configuration: configuration
            )
        )
    }

    var body: some View {
        let itemIDs = items.map(\.id)

        VStack(spacing: 6) {
            HStack(spacing: 0) {
                CarouselArrowButton(
                    systemName: "chevron.left",
                    isVisible: coordinator.hasMultiplePages && isHovering,
                    isEnabled: coordinator.canMoveBackward
                ) {
                    coordinator.movePage(by: -1)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: configuration.itemSpacing) {
                        ForEach(items) { item in
                            content(item)
                                .frame(width: coordinator.layoutSnapshot.itemWidth)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .scrollTargetLayout()
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $coordinator.leadingItemID, anchor: .leading)

                CarouselArrowButton(
                    systemName: "chevron.right",
                    isVisible: coordinator.hasMultiplePages && isHovering,
                    isEnabled: coordinator.canMoveForward
                ) {
                    coordinator.movePage(by: 1)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onHover { isHovering = $0 }
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { width in
                coordinator.updateAvailableWidth(width)
            }
            .onAppear {
                coordinator.synchronize(
                    itemIDs: itemIDs,
                    configuration: configuration
                )
            }
            .onChange(of: itemIDs) { _, newItemIDs in
                coordinator.synchronize(itemIDs: newItemIDs, configuration: configuration)
            }
            .onChange(of: configuration) { _, newConfiguration in
                coordinator.synchronize(
                    itemIDs: itemIDs,
                    configuration: newConfiguration
                )
            }
            .task(id: coordinator.autoPagingTaskID) {
                await coordinator.runAutoPagingLoop()
            }

            if configuration.showsPageIndicators && coordinator.hasMultiplePages {
                CarouselPageIndicator(
                    pageCount: coordinator.pageCount,
                    currentPageIndex: coordinator.currentPageIndex
                )
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

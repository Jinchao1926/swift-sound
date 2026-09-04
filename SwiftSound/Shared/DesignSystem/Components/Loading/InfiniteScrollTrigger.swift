//
//  InfiniteScrollTrigger.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import SwiftUI

struct InfiniteScrollFooter<Page: PaginatedValue>: View {
    let state: Loadable<Page>
    let onLoadMore: () async -> Void

    var body: some View {
        if let page = state.value {
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: 1)
                    .infiniteScrollTrigger(
                        canLoadMore: page.canLoadMore,
                        isLoading: state.isLoading,
                        loadKey: page.items.count,
                        perform: onLoadMore
                    )

                if state.isLoading {
                    LoadingIndicatorView()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

extension View {
    /// Triggers `action` once for each `loadKey` while this view is present.
    /// Put it on a sentinel view at the end of a lazy container.
    func infiniteScrollTrigger<LoadKey: Equatable>(
        canLoadMore: Bool,
        isLoading: Bool,
        loadKey: LoadKey,
        perform action: @escaping () async -> Void
    ) -> some View {
        modifier(
            InfiniteScrollTriggerModifier(
                canLoadMore: canLoadMore,
                isLoading: isLoading,
                loadKey: loadKey,
                action: action
            )
        )
    }
}

private struct InfiniteScrollTriggerModifier<LoadKey: Equatable>: ViewModifier {
    let canLoadMore: Bool
    let isLoading: Bool
    let loadKey: LoadKey
    let action: () async -> Void

    @State private var lastTriggeredLoadKey: LoadKey?

    func body(content: Content) -> some View {
        content
            .task(id: loadKey) {
                guard canLoadMore,
                      !isLoading,
                      lastTriggeredLoadKey != loadKey else {
                    return
                }

                lastTriggeredLoadKey = loadKey
                await action()
            }
    }
}

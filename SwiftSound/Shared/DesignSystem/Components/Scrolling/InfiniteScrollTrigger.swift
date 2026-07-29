//
//  InfiniteScrollTrigger.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import SwiftUI

struct InfiniteScrollFooter<LoadKey: Equatable>: View {
    let canLoadMore: Bool
    let isLoading: Bool
    let loadKey: LoadKey
    let onLoadMore: () async -> Void

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 1)
                .infiniteScrollTrigger(
                    canLoadMore: canLoadMore,
                    isLoading: isLoading,
                    loadKey: loadKey,
                    perform: onLoadMore
                )

            if isLoading {
                loadingIndicator
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var loadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .controlSize(.small)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 19.5)
    }
}

extension View {
    /// Triggers `action` once when this view appears for the current `loadKey`.
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
            .onAppear {
                triggerIfNeeded()
            }
    }

    private func triggerIfNeeded() {
        guard canLoadMore,
              !isLoading,
              lastTriggeredLoadKey != loadKey else {
            return
        }

        lastTriggeredLoadKey = loadKey

        Task { await action() }
    }
}

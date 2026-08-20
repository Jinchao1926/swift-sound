//
//  View+ScrollIndicators.swift
//  SwiftSound
//

import SwiftUI

private struct ScrollIndicatorsWhileScrollingModifier: ViewModifier {
    let axes: Axis.Set
    let hideDelay: Duration
    let minimumOverflow: CGFloat

    @State private var isScrolling = false
    @State private var isIndicatorVisible = false
    @State private var hasScrollableContent = false

    func body(content: Content) -> some View {
        content
            .scrollIndicators(
                shouldShowIndicators ? .visible : .hidden,
                axes: axes
            )
            .onScrollPhaseChange { _, phase in
                isScrolling = phase != .idle
                if isScrolling {
                    isIndicatorVisible = true
                }
            }
            .onScrollGeometryChange(for: Bool.self) { geometry in
                let hasHorizontalOverflow = axes.contains(.horizontal)
                    && geometry.contentSize.width > geometry.containerSize.width + minimumOverflow
                let hasVerticalOverflow = axes.contains(.vertical)
                    && geometry.contentSize.height > geometry.containerSize.height + minimumOverflow

                return hasHorizontalOverflow || hasVerticalOverflow
            } action: { _, hasOverflow in
                hasScrollableContent = hasOverflow
            }
            .task(id: isScrolling) {
                guard !isScrolling else { return }

                do {
                    try await Task.sleep(for: hideDelay)
                } catch {
                    return
                }

                guard !Task.isCancelled else { return }
                isIndicatorVisible = false
            }
    }

    private var shouldShowIndicators: Bool {
        hasScrollableContent && isIndicatorVisible
    }
}

extension View {
    func scrollIndicatorsWhileScrolling(
        _ axes: Axis.Set = .vertical,
        hideDelay: Duration = .milliseconds(600),
        minimumOverflow: CGFloat = 0.5
    ) -> some View {
        modifier(
            ScrollIndicatorsWhileScrollingModifier(
                axes: axes,
                hideDelay: hideDelay,
                minimumOverflow: max(0, minimumOverflow)
            )
        )
    }
}

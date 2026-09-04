//
//  LoadingPlaceholder.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

private struct LoadingPlaceholderModifier<Loading: View>: ViewModifier {
    let isLoading: Bool
    let loading: Loading

    func body(content: Content) -> some View {
        if isLoading {
            loading
        } else {
            content
        }
    }
}

extension View {
    func loadingPlaceholder<Loading: View>(
        _ isLoading: Bool,
        @ViewBuilder loading: () -> Loading
    ) -> some View {
        modifier(
            LoadingPlaceholderModifier(
                isLoading: isLoading,
                loading: loading()
            )
        )
    }

    func loadingPlaceholder(_ isLoading: Bool) -> some View {
        loadingPlaceholder(isLoading) {
            LoadingIndicatorView()
        }
    }
}

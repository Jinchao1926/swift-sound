//
//  LoadableModifier.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

private struct LoadableModifier<Value>: ViewModifier {
    let state: Loadable<Value>
    let isEmpty: (Value) -> Bool
    let retry: (() async -> Void)?

    @ViewBuilder
    func body(content: Content) -> some View {
        switch state {
        case .idle:
            content
        case .loading(let value):
            if let value {
                contentOrEmpty(value, content: content)
            } else {
                LoadingIndicatorView()
            }
        case .loaded(let value):
            contentOrEmpty(value, content: content)
        case .failed(let error):
            if let retry {
                LoadableFailureView(error: error, retry: retry)
            } else {
                content
            }
        }
    }

    @ViewBuilder
    private func contentOrEmpty(_ value: Value, content: Content) -> some View {
        if isEmpty(value) {
            EmptyStateView()
        } else {
            content
        }
    }
}

extension View {
    func loadable<Value: LoadableValue>(
        state: Loadable<Value>,
        retry: (() async -> Void)? = nil
    ) -> some View {
        loadable(
            state: state,
            isEmpty: { $0.isEmpty },
            retry: retry
        )
    }

    func loadable<Value>(
        state: Loadable<Value>,
        isEmpty: @escaping (Value) -> Bool = { _ in false },
        retry: (() async -> Void)? = nil
    ) -> some View {
        modifier(
            LoadableModifier(
                state: state,
                isEmpty: isEmpty,
                retry: retry
            )
        )
    }
}

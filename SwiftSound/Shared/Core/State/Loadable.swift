//
//  Loadable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import Foundation

// MARK: - LoadableValue
protocol LoadableValue {
    var isEmpty: Bool { get }
}

extension Array: LoadableValue {}

// MARK: - Loadable
enum Loadable<Value> {
    case idle
    case loading(Value? = nil)
    case loaded(Value)
    case failed(Error)
}

extension Loadable {
    var value: Value? {
        switch self {
        case .loaded(let value):
            return value
        case .loading(let value):
            return value
        case .idle, .failed:
            return nil
        }
    }

    func value(or defaultValue: @autoclosure () -> Value) -> Value {
        value ?? defaultValue()
    }

    func value<Output>(
        _ keyPath: KeyPath<Value, Output>,
        or defaultValue: @autoclosure () -> Output
    ) -> Output {
        value?[keyPath: keyPath] ?? defaultValue()
    }

    var error: Error? {
        if case let .failed(error) = self {
            return error
        }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var isInitialLoading: Bool {
        guard case .loading(let value) = self else { return false }

        if case .none = value {
            return true
        }

        return false
    }

    var isLoadedOrLoading: Bool {
        switch self {
        case .loading, .loaded:
            return true
        case .idle, .failed:
            return false
        }
    }
}

extension Loadable where Value: LoadableValue {
    var isValueEmpty: Bool {
        value?.isEmpty ?? false
    }
}

extension Loadable where Value: RangeReplaceableCollection {
    var items: Value {
        value(or: .init())
    }
}

extension Loadable where Value: PaginatedValue {
    var items: [Value.Element] {
        value(\.items, or: [])
    }

    var canLoadMore: Bool {
        value(\.canLoadMore, or: false)
    }
}

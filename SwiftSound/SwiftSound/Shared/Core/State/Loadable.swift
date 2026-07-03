//
//  Loadable.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/1.
//

import Foundation

enum Loadable<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(Error)
}

extension Loadable {
    var value: Value? {
        if case let .loaded(value) = self {
            return value
        }
        return nil
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

    var isLoadedOrLoading: Bool {
        switch self {
        case .loading, .loaded:
            return true
        case .idle, .failed:
            return false
        }
    }
}

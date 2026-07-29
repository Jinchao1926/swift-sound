//
//  Loadable.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import Foundation

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

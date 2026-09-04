//
//  Paginated.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import Foundation

protocol PaginatedResponse: Decodable {
    associatedtype Element

    var items: [Element] { get }
    var canLoadMore: Bool { get }
}

protocol PaginatedValue {
    associatedtype Element

    var items: [Element] { get }
    var canLoadMore: Bool { get }
}

struct Paginated<Element>: PaginatedValue, LoadableValue {
    private(set) var items: [Element]
    private(set) var canLoadMore: Bool

    var isEmpty: Bool { items.isEmpty }

    var nextOffset: Int { items.count }

    init(items: [Element] = [], canLoadMore: Bool = false) {
        self.items = items
        self.canLoadMore = canLoadMore
    }

    init<Response: PaginatedResponse>(_ response: Response) where Response.Element == Element {
        self.init(items: response.items, canLoadMore: response.canLoadMore)
    }

    mutating func replace<Response: PaginatedResponse>(with response: Response) where Response.Element == Element {
        items = response.items
        canLoadMore = response.canLoadMore
    }

    mutating func append<Response: PaginatedResponse>(_ response: Response) where Response.Element == Element {
        items.append(contentsOf: response.items)
        canLoadMore = response.canLoadMore
    }
}

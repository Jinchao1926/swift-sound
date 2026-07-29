//
//  DataTableSortState.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import Foundation

struct DataTableSortState {
    var columnID: String?
    var order: DataTableSortOrder?

    // 默认 -> 升序 -> 降序
    mutating func cycle(columnID selectedColumnID: String) {
        guard columnID == selectedColumnID else {
            columnID = selectedColumnID
            order = .ascending
            return
        }

        switch order {
        case .none:
            order = .ascending
        case .ascending:
            order = .descending
        case .descending:
            columnID = nil
            order = nil
        }
    }
}

enum DataTableSortOrder {
    case ascending
    case descending
}

enum DataTableSortDisplayState {
    case `default`
    case ascending
    case descending

    init(order: DataTableSortOrder?) {
        switch order {
        case .ascending:
            self = .ascending
        case .descending:
            self = .descending
        case .none:
            self = .default
        }
    }

    var systemImage: String {
        switch self {
        case .default:
            return "arrow.up.arrow.down"
        case .ascending:
            return "arrow.up"
        case .descending:
            return "arrow.down"
        }
    }

    var title: String {
        switch self {
        case .default:
            return "默认"
        case .ascending:
            return "升序"
        case .descending:
            return "降序"
        }
    }
}

extension Int {
    func compare(_ other: Int) -> ComparisonResult {
        if self < other { return .orderedAscending }
        if self > other { return .orderedDescending }
        return .orderedSame
    }
}

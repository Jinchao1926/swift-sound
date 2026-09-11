//
//  RadioRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

enum RadioRoute: RouteTabProtocol {
    case programs
    case comments

    var title: String {
        switch self {
        case .programs:
            return "声音"
        case .comments:
            return "评论"
        }
    }
}

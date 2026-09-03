//
//  UserRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import Foundation

enum UserRoute: RouteTabProtocol {
    case playlists
    case notes
    case radios

    var title: String {
        switch self {
        case .playlists:
            return "音乐"
        case .notes:
            return "笔记"
        case .radios:
            return "播客"
        }
    }
}

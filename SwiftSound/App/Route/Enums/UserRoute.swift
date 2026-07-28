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
    case podcasts

    var title: String {
        switch self {
        case .playlists:
            return "歌单"
        case .notes:
            return "笔记"
        case .podcasts:
            return "播客"
        }
    }
}

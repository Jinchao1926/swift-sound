//
//  PlaylistRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/12.
//

import Foundation

enum PlaylistRoute: RouteTabProtocol {
    case songs
    case comments
    case subscribers

    var title: String {
        switch self {
        case .songs:
            return "歌曲"
        case .comments:
            return "评论"
        case .subscribers:
            return "收藏者"
        }
    }
}

//
//  AlbumRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/30.
//

import Foundation

enum AlbumRoute: RouteTabProtocol {
    case songs
    case comments
    case profile

    var title: String {
        switch self {
        case .songs:
            return "歌曲"
        case .comments:
            return "评论"
        case .profile:
            return "专辑详情"
        }
    }
}

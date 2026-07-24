//
//  ArtistRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import Foundation

enum ArtistRoute: RouteTabProtocol {
    case songs
    case albums
    case mvs
    case profile
    case similarArtists
    case performances

    var title: String {
        switch self {
        case .songs:
            return "歌曲"
        case .albums:
            return "专辑"
        case .mvs:
            return "MV"
        case .profile:
            return "歌手详情"
        case .similarArtists:
            return "相似歌手"
        case .performances:
            return "演出"
        }
    }
}

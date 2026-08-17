//
//  FeaturedRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation

enum FeaturedRoute: SecondaryRouteProtocol {
    case featured
    case playlistDiscovery
    case ranking
    case artist
    case vip

    var destinationRoute: AppRoute { .featured(secondary: self) }

    var title: String {
        switch self {
        case .featured:
            return "精选"
        case .playlistDiscovery:
            return "歌单广场"
        case .ranking:
            return "排行榜"
        case .artist:
            return "歌手"
        case .vip:
            return "VIP"
        }
    }
}

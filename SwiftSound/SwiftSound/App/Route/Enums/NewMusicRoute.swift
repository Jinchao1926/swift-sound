//
//  NewMusicRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

enum NewMusicRoute: SecondaryRouteProtocol {
    case songs
    case albums

    var destinationRoute: AppRoute { .newMusic(secondary: self) }

    var title: String {
        switch self {
        case .songs:
            return "新歌速递"
        case .albums:
            return "新碟上架"
        }
    }
}

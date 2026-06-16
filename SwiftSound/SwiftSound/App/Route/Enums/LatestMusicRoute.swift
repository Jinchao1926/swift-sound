//
//  LatestMusicRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

enum LatestMusicRoute: SecondaryRouteProtocol {
    case newTrack
    case newAlbum

    var destinationRoute: AppRoute { .latestMusic(secondary: self) }

    var title: String {
        switch self {
        case .newTrack:
            return "新歌速递"
        case .newAlbum:
            return "新碟上架"
        }
    }
}

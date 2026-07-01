//
//  SongDetailsTab.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import Foundation

enum SongDetailsTab: String, CaseIterable, Identifiable {
    case lyrics
    case wiki
    case similar

    var id: Self { self }

    var title: String {
        switch self {
        case .lyrics:
            "歌词"
        case .wiki:
            "百科"
        case .similar:
            "相似推荐"
        }
    }
}

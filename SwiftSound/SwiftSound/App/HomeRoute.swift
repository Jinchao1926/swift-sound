//
//  HomeRoute.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Foundation

enum HomeRoute: String, CaseIterable, Identifiable {
    case featured
    case podcast
    case follow
    case favorite
    case played
    case download

    var id: Self { self }

    var title: String {
        switch self {
        case .featured:
            return "精选"
        case .podcast:
            return "播客"
        case .follow:
            return "关注"
        case .favorite:
            return "我喜欢的音乐"
        case .played:
            return "最近播放"
        case .download:
            return "下载管理"
        }
    }

    var systemImage: String {
        switch self {
        case .featured:
            return "music.pages.fill"
        case .podcast:
            return "dot.radiowaves.left.and.right"
        case .follow:
            return "bubble.fill"
        case .favorite:
            return "heart.fill"
        case .played:
            return "clock.fill"
        case .download:
            return "arrow.down.circle.fill"
        }
    }
}

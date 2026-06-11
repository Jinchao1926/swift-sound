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
            return "Featured"
        case .podcast:
            return "Podcast"
        case .follow:
            return "Follow"
        case .favorite:
            return "Favorite"
        case .played:
            return "Played"
        case .download:
            return "Download"
        }
    }

    var systemImage: String {
        switch self {
        case .featured:
            return "sparkles"
        case .podcast:
            return "dot.radiowaves.left.and.right"
        case .follow:
            return "person.2"
        case .favorite:
            return "heart"
        case .played:
            return "clock.arrow.circlepath"
        case .download:
            return "arrow.down.circle"
        }
    }
}

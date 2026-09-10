//
//  RankingInfoProviding.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Foundation

protocol RadioProviding: Identifiable {
    var id: Int { get }
    var name: String { get }
    var picUrl: String { get }
    var rcmdtext: String? { get }
    var programCount: Int? { get }
    var subCount: Int? { get }
    var playCount: Int? { get }

    var creatorID: Int? { get }
    var creatorName: String { get }
    var imageURL: URL? { get }
}
extension RadioProviding {
    var imageURL: URL? { URL(string: picUrl) }
}

protocol RankingInfoProviding: Identifiable {
    var lastRank: Int { get }
    var rank: Int { get }
    var score: Int { get }
}

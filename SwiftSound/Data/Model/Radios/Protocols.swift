//
//  RankingInfoProviding.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Foundation

// MARK: - RadioProviding
protocol RadioProviding: Identifiable {
    var id: Int { get }
    var name: String { get }
    var picUrl: String { get }
    var creatorID: Int? { get }
    var creatorName: String { get }

    func getRecommendText() -> String?
    func getProgramCount() -> Int?
    func getPlayCount() -> Int?
}

extension RadioProviding {
    var imageURL: URL? { URL(string: picUrl) }
}

// MARK: - RankingInfoProviding
protocol RankingInfoProviding: Identifiable {
    var lastRank: Int { get }
    var rank: Int { get }
    var score: Int { get }
}

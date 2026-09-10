//
//  RadioChart.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/10.
//

import Foundation

// MARK: - RadioChart
struct RadioChart: Decodable, RadioProviding, RankingInfoProviding {
    let id: Int
    let name: String
    let rcmdtext: String?
    let picUrl: String
    let createTime: Int
    let categoryId: Int
    let category: String
    let programCount: Int?
    let subCount: Int?
    let playCount: Int?
    let dj: User
    let lastRank: Int
    let rank: Int
    let score: Int

    var creatorID: Int? { dj.userId }
    var creatorName: String { dj.nickname }
}

// MARK: - RadioPaidChart
struct RadioPaidChart: Decodable, RadioProviding, RankingInfoProviding {
    let id: Int
    let name: String
    let picUrl: String
    let creatorName: String
    let lastRank: Int
    let rank: Int
    let score: Int
}
extension RadioPaidChart {
    var rcmdtext: String? { nil }
    var programCount: Int? { nil }
    var subCount: Int? { nil }
    var playCount: Int? { nil }
    var creatorID: Int? { nil }
}

extension RadioPaidChart {
    var imageURL: URL? { URL(string: picUrl) }
}

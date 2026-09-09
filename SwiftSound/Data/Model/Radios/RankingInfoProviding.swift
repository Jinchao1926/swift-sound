//
//  RankingInfoProviding.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Foundation

protocol RankingInfoProviding: Identifiable {
    var lastRank: Int { get }
    var rank: Int { get }
    var score: Int { get }
}

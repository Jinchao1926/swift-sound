//
//  ProgramChart.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

struct ProgramChart: Decodable, RankingInfoProviding {
    let program: Program
    let programFeeType: Int
    let rank: Int
    let lastRank: Int
    let score: Int

    var id: Int { program.id }
}

//
//  ProgramChart+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/14.
//

import Foundation

#if DEBUG
extension ProgramChart {
    static let preview = ProgramChart(
        program: .preview,
        programFeeType: 0,
        rank: 1,
        lastRank: 2,
        score: 0
    )
}
#endif

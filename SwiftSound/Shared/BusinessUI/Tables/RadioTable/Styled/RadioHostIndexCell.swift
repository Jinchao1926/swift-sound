//
//  RadioHostIndexCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioHostIndexCell: View {
    let index: Int
    let rankingInfo: any RankingInfoProviding

    var body: some View {
        VStack(spacing: 0) {
            Text(String(format: "%02d", index))
                .font(.font12)
                .foregroundStyle(Color.textSecondary)
                .frame(height: Layout.iconSize)

            rankChangeView
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }

    @ViewBuilder
    private var rankChangeView: some View {
        if rankingInfo.lastRank < 0 {
            Text("新")
                .font(.font12)
                .foregroundStyle(Color.green)
        } else if rankingInfo.rank > rankingInfo.lastRank {
            rankChangeLabel(
                systemName: "arrowtriangle.up.fill",
                value: rankingInfo.rank - rankingInfo.lastRank,
                color: Color.accentPrimary
            )
        } else if rankingInfo.rank < rankingInfo.lastRank {
            rankChangeLabel(
                systemName: "arrowtriangle.down.fill",
                value: rankingInfo.lastRank - rankingInfo.rank,
                color: Color.green
            )
        } else {
            Text("--")
                .font(.font12)
                .foregroundStyle(Color.gray)
        }
    }

    private func rankChangeLabel(
        systemName: String,
        value: Int,
        color: Color
    ) -> some View {
        HStack(spacing: Layout.rankContentSpacing) {
            Image(systemName: systemName)
            Text(String(value))
        }
        .font(.font9)
        .foregroundStyle(color)
    }

    private enum Layout {
        static let iconSize: CGFloat = 26
        static let rankContentSpacing: CGFloat = 2
    }
}

private struct Rank: RankingInfoProviding {
    var id: Int
    var lastRank: Int
    var rank: Int
    var score: Int
}

#Preview {
    VStack {
        RadioHostIndexCell(
            index: 1,
            rankingInfo: Rank(id: 1, lastRank: -1, rank: 1, score: 0)
        )
        RadioHostIndexCell(
            index: 2,
            rankingInfo: Rank(id: 1, lastRank: 1, rank: 2, score: 0)
        )
        RadioHostIndexCell(
            index: 3,
            rankingInfo: Rank(id: 1, lastRank: 4, rank: 2, score: 0)
        )
        RadioHostIndexCell(
            index: 4,
            rankingInfo: Rank(id: 1, lastRank: 3, rank: 3, score: 0)
        )
    }
    .background(Color.surfacePrimary)
    .padding()
}

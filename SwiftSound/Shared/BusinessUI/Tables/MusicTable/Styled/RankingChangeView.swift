//
//  RankingChangeView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import SwiftUI

struct RankingChangeView: View {
    let ranking: any RankingInfoProviding

    var body: some View {
        if ranking.lastRank < 0 {
            Text("新")
                .font(.font12)
                .foregroundStyle(Color.green)
        } else if ranking.rank < ranking.lastRank {
            rankChangeLabel(
                systemName: "arrowtriangle.up.fill",
                value: ranking.lastRank - ranking.rank,
                color: Color.accentPrimary
            )
        } else if ranking.rank > ranking.lastRank {
            rankChangeLabel(
                systemName: "arrowtriangle.down.fill",
                value: ranking.rank - ranking.lastRank,
                color: Color.green
            )
        } else {
            Text("--")
                .font(.font12)
                .foregroundStyle(Color.gray)
        }
    }
}

private extension RankingChangeView {
    func rankChangeLabel(
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

    enum Layout {
        static let iconSize: CGFloat = 28
        static let rankContentSpacing: CGFloat = 2
    }
}

#Preview {
    VStack(spacing: 5) {
        RankingChangeView(ranking: RankingPreview.new)
        RankingChangeView(ranking: RankingPreview.up)
        RankingChangeView(ranking: RankingPreview.down)
        RankingChangeView(ranking: RankingPreview.unchange)
    }
    .padding()
}

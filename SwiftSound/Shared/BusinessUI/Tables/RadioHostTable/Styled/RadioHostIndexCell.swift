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

            RankingChangeView(ranking: rankingInfo)
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }

    private enum Layout {
        static let iconSize: CGFloat = 26
    }
}

#Preview {
    VStack {
        RadioHostIndexCell(index: 1, rankingInfo: RankingPreview.new)
        RadioHostIndexCell(index: 2, rankingInfo: RankingPreview.down)
        RadioHostIndexCell(index: 3, rankingInfo: RankingPreview.up)
        RadioHostIndexCell(index: 4, rankingInfo: RankingPreview.unchange)
    }
    .background(Color.surfacePrimary)
    .padding()
}

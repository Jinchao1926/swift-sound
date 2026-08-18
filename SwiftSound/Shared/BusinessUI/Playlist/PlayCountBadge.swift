//
//  PlayCountBadge.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct PlayCountBadge: View {
    let count: Int
    let fontSize: CGFloat

    init(count: Int, fontSize: CGFloat = 14) {
        self.count = count
        self.fontSize = fontSize
    }

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "headphones")
                .font(.system(size: fontSize - 2))

            Text(count.formattedCount())
                .font(.system(size: fontSize))
                .fontWeight(.medium)
        }
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack(alignment: .leading) {
        PlayCountBadge(count: 110000)

        PlayCountBadge(count: 6484366336)
    }
    .padding()
    .background(Color.green)
}

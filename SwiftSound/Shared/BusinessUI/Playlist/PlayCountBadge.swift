//
//  PlayCountBadge.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct PlayCountBadge: View {
    let count: Int

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "headphones")
                .font(.font12)

            Text(count.playCountText)
                .font(.font14)
        }
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack {
        PlayCountBadge(count: 110000)
    }
    .padding()
    .background(Color.green)
}

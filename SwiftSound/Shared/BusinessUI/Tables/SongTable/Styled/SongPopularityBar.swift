//
//  SongPopularityBar.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/6.
//

import SwiftUI

struct SongPopularityBar: View {
    let value: Int

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.gray.opacity(0.22))

            Capsule()
                .fill(Color.accentPrimary.opacity(0.72))
                .frame(width: Layout.width * ratio)
        }
        .frame(width: Layout.width, height: Layout.height)
    }

    private var ratio: CGFloat {
        CGFloat(value.clamped(to: 0...100)) / 100
    }

    private enum Layout {
        static let width: CGFloat = 60
        static let height: CGFloat = 4
    }
}

#Preview {
    SongPopularityBar(value: 70)
        .padding()
}

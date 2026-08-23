//
//  LevelView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import SwiftUI

struct LevelView: View {
    let level: Int

    var body: some View {
        Text("LV. \(level)")
            .font(.font12)
            .foregroundStyle(Color.textPrimary)
            .padding(.horizontal, 4)
            .background(
                Capsule(style: .continuous)
                    .stroke(Color.divider, lineWidth: 1)
                    .fill(Color.surfaceSecondary)
            )
    }
}

#Preview {
    LevelView(level: 1)
        .padding()
}

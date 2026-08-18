//
//  PlayButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct PlayButton: View {
    let size: CGFloat

    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button {
            // Playback wiring belongs to the player feature.
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: size, weight: .regular))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }
}

#Preview {
    VStack {
        PlayButton()
    }
    .padding()
    .background(Color.surfacePrimary)
}

//
//  MusicTableFavoriteButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct MusicTableFavoriteButton: View {
    @State private var isLiked: Bool

    init(liked: Bool) {
        self._isLiked = State(initialValue: liked)
    }

    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.font16)
                .foregroundStyle(isLiked ? Color.accentPrimary : Color.textSecondary)
                .frame(width: Layout.actionSize, height: Layout.actionSize)
        }
        .buttonStyle(.plain)
        .help(isLiked ? "取消喜欢" : "喜欢")
        .pointerStyle(.link)
    }

    private enum Layout {
        static let actionSize: CGFloat = 20
    }
}

#Preview {
    HStack {
        MusicTableFavoriteButton(liked: false)
        MusicTableFavoriteButton(liked: true)
    }
    .padding()
}

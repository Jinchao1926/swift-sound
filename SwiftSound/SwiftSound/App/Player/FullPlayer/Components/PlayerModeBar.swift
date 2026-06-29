//
//  PlayerModeBar.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/29.
//

import SwiftUI

struct PlayerModeBar: View {
    var body: some View {
        HStack(spacing: Layout.playerModeBarSpacing) {
            Spacer()

            PlayerModeBarHoverButton {
                HStack(spacing: 5) {
                    Image(systemName: "power.circle")
                        .font(.font16)

                    Text("播放器模式")
                        .font(.font14)
                }
            }

            Rectangle()
                .fill(Color.textTertiaryOnDark)
                .frame(width: 1, height: 16)

            PlayerModeBarHoverButton {
                Image(systemName: "rectangle.on.rectangle")
                    .font(.font14)
                    .frame(width: Layout.iconButtonSize, height: Layout.iconButtonSize)
            }
            .help("迷你播放器")
        }
        .padding(.trailing, Layout.playerModeBarTrailingInset)
        .frame(height: Layout.playerModeBarHeight)
        .frame(maxWidth: .infinity)
    }

    private enum Layout {
        static let playerModeBarSpacing: CGFloat = 10
        static let playerModeBarHeight: CGFloat = 100
        static let playerModeBarTrailingInset: CGFloat = 36
        static let iconButtonSize: CGFloat = 20
    }
}

private struct PlayerModeBarHoverButton<Content: View>: View {
    let content: () -> Content

    @State private var isHovering = false

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .foregroundStyle(isHovering ? Color.textPrimaryOnDark : Color.textSecondaryOnDark)
            .padding(.horizontal, 6)
            .frame(height: 26)
            .contentShape(Capsule())
            .onHover { isHovering = $0 }
            .pointerStyle(.link)
            .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

#Preview {
    VStack {
        PlayerModeBar()
    }
    .background(Color(hex: 0x151515))
}

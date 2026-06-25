//
//  PlayerView.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/24.
//

import SwiftUI

struct PlayerView: View {
    let model: PlayerBarModel
    let callback: PlayerBarCallback
    let onCollapse: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header

            Spacer(minLength: 0)

            PlayerBarView(
                model: model,
                callback: callback,
                onActivate: onCollapse
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: 0x161616))
        .contentShape(Rectangle())
    }

    private var header: some View {
        HStack {
            Button(action: onCollapse) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.82))
                    .frame(width: Layout.collapseButtonSize, height: Layout.collapseButtonSize)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("收起播放器")

            Spacer()
        }
        .padding(.horizontal, Layout.horizontalInset)
        .padding(.top, Layout.topInset)
    }
}

private extension PlayerView {
    enum Layout {
        static let collapseButtonSize: CGFloat = 44
        static let horizontalInset: CGFloat = 36
        static let topInset: CGFloat = 18
    }
}

#Preview {
    PlayerView(
        model: .preview(),
        callback: .preview,
        onCollapse: {}
    )
    .frame(width: 1280, height: 800)
}

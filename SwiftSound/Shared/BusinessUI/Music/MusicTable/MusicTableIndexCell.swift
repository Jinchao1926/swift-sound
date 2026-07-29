//
//  MusicTableIndexCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct MusicTableIndexCell: View {
    let index: Int
    let isRowHovering: Bool
    let playAction: () -> Void

    @State private var isIconHovering = false

    var body: some View {
        ZStack {
            Text(String(format: "%02d", index))
                .font(.font12)
                .foregroundStyle(Color.textSecondary)
                .opacity(isRowHovering ? 0 : 1)

            Button(action: playAction) {
                Image(systemName: "play.fill")
                    .font(.font14)
                    .foregroundStyle(iconColor)
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
            }
            .buttonStyle(.plain)
            .help("播放")
            .pointerStyle(.link)
            .opacity(isRowHovering ? 1 : 0)
            .allowsHitTesting(isRowHovering)
            .onHover { isIconHovering = $0 }
        }
        .frame(width: Layout.iconSize, height: Layout.iconSize)
        .onChange(of: isRowHovering) { _, isRowHovering in
            if !isRowHovering {
                isIconHovering = false
            }
        }
    }

    private var iconColor: Color {
        isIconHovering ? Color(hex: 0x394154) : Color(hex: 0x7E8491)
    }

    private enum Layout {
        static let iconSize: CGFloat = 28
    }
}

#Preview {
    VStack {
        MusicTableIndexCell(index: 1, isRowHovering: false) {}
        MusicTableIndexCell(index: 2, isRowHovering: true) {}
    }
    .padding()
}

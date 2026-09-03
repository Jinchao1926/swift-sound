//
//  MusicTableIndexCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct MusicTableIndexCell: View {
    let index: Int
    let rowState: MusicTableRowState
    let action: () -> Void

    @State private var isIconHovering = false

    init(
        index: Int,
        rowState: MusicTableRowState = .init(),
        action: @escaping () -> Void
    ) {
        self.index = index
        self.rowState = rowState
        self.action = action
    }

    var body: some View {
        ZStack {
            Text(String(format: "%02d", index))
                .font(.font12)
                .foregroundStyle(Color.textSecondary)
                .opacity(showsIndex ? 1 : 0)

            Image(systemName: "waveform.mid")
                .font(.font20)
                .foregroundStyle(Color.accentPrimary)
                .frame(width: Layout.iconSize, height: Layout.iconSize)
                .symbolEffect(
                    .variableColor.iterative.nonReversing,
                    options: .repeating,
                    isActive: rowState.isPlaying
                )
                .opacity(showsPlayingIndicator ? 1 : 0)

            Button(action: action) {
                Image(systemName: controlSystemName)
                    .font(.font14)
                    .foregroundStyle(iconColor)
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
            }
            .buttonStyle(.plain)
            .help(controlHelpText)
            .pointerStyle(.link)
            .opacity(showsControl ? 1 : 0)
            .allowsHitTesting(showsControl)
            .onHover { isIconHovering = $0 }
        }
        .frame(width: Layout.iconSize, height: Layout.iconSize)
        .onChange(of: rowState.isHovering) { _, isHovering in
            if !isHovering {
                isIconHovering = false
            }
        }
    }

    private var showsIndex: Bool { !rowState.isCurrent && !rowState.isHovering }
    private var showsPlayingIndicator: Bool { rowState.isPlaying && !showsControl }
    private var showsControl: Bool { rowState.isHovering || (rowState.isCurrent && !rowState.isPlaying) }

    private var controlSystemName: String {
        rowState.isPlaying ? "pause.fill" : "play.fill"
    }

    private var controlHelpText: String {
        rowState.isPlaying ? "暂停" : "播放"
    }

    private var iconColor: Color {
        isIconHovering || rowState.isPlaying ? Color(hex: 0x394154) : Color(hex: 0x7E8491)
    }

    private enum Layout {
        static let iconSize: CGFloat = 28
    }
}

#Preview {
    VStack {
        MusicTableIndexCell(index: 1) {}
        MusicTableIndexCell(index: 2, rowState: .init(isHovering: true)) {}
        MusicTableIndexCell(index: 3, rowState: .init(playbackStatus: .currentPaused)) {}
        MusicTableIndexCell(index: 4, rowState: .init(playbackStatus: .currentPlaying)) {}
        MusicTableIndexCell(index: 5, rowState: .init(isHovering: true, playbackStatus: .currentPlaying)) {}
    }
    .padding()
}

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
    let rankingInfo: (any RankingInfoProviding)?
    let action: (() -> Void)?

    @State private var isIconHovering = false

    init(
        index: Int,
        rowState: MusicTableRowState = .init(),
        rankingInfo: (any RankingInfoProviding)? = nil,
        action: (() -> Void)? = nil
    ) {
        self.index = index
        self.rowState = rowState
        self.rankingInfo = rankingInfo
        self.action = action
    }

    var body: some View {
        VStack(spacing: 0) {
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

                Button { action?() } label: {
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

            if let rankingInfo {
                RankingChangeView(ranking: rankingInfo)
            }
        }
        .frame(width: Layout.iconSize)
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
    HStack {
        VStack {
            MusicTableIndexCell(index: 1)
                .frame(height: 50)
            MusicTableIndexCell(index: 2, rowState: .init(isHovering: true))
                .frame(height: 50)
            MusicTableIndexCell(index: 3, rowState: .init(playbackStatus: .currentPaused))
                .frame(height: 50)
            MusicTableIndexCell(index: 4, rowState: .init(playbackStatus: .currentPlaying))
                .frame(height: 50)
            MusicTableIndexCell(index: 5, rowState: .init(isHovering: true, playbackStatus: .currentPlaying))
                .frame(height: 50)
        }

        VStack {
            MusicTableIndexCell(index: 1, rankingInfo: RankingPreview.new)
                .frame(height: 50)
            MusicTableIndexCell(
                index: 2,
                rowState: .init(isHovering: true),
                rankingInfo: RankingPreview.up
            )
            .frame(height: 50)
            MusicTableIndexCell(
                index: 3,
                rowState: .init(playbackStatus: .currentPaused),
                rankingInfo: RankingPreview.down
            )
            .frame(height: 50)
            MusicTableIndexCell(
                index: 4,
                rowState: .init(playbackStatus: .currentPlaying),
                rankingInfo: RankingPreview.unchange
            )
            .frame(height: 50)
            MusicTableIndexCell(
                index: 5,
                rowState: .init(isHovering: true, playbackStatus: .currentPlaying),
                rankingInfo: RankingPreview.up
            )
            .frame(height: 50)
        }
    }
    .background(Color.surfacePrimary)
    .padding()
}

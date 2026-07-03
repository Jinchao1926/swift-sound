//
//  LyricsLineView.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/3.
//

import SwiftUI
import Foundation

struct LyricsLineView: View {
    let line: LyricLine
    let distance: Int?
    let showsSeekControl: Bool
    let onSeek: (TimeInterval) -> Void

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            Text(line.text.isEmpty ? " " : line.text)
                .font(.system(size: fontSize, weight: distance == 0 ? .semibold : .regular))
                .foregroundStyle(foregroundColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            if showsSeekControl {
                seekButton
            }
        }
        .frame(height: Layout.rowHeight)
    }

    private var seekButton: some View {
        Button {
            onSeek(line.time / 1000)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "play.fill")
                    .font(.system(size: 8, weight: .semibold))

                Text(formattedTime(line.time))
                    .font(.font13)
                    .monospacedDigit()
            }
            .foregroundStyle(Color.white)
            .padding(.horizontal, 10)
            .frame(height: Layout.seekButtonHeight)
            .background {
                Capsule()
                    .fill(Color.white.opacity(0.14))
            }
            .overlay {
                Capsule()
                    .stroke(Color.white.opacity(0.36), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var foregroundColor: Color {
        if distance == 0 {
            return .white
        }
        return Color.textPrimaryOnDark.opacity(opacity)
    }

    private var fontSize: CGFloat {
        distance == 0 ? Layout.activeLineFontSize : Layout.lineFontSize
    }

    private var opacity: Double {
        guard let distance else { return 0.04 }

        switch distance {
        case 0:
            return 1
        case 1:
            return 0.38
        case 2:
            return 0.18
        case 3:
            return 0.08
        default:
            return 0.04
        }
    }

    private func formattedTime(_ milliseconds: TimeInterval) -> String {
        let totalSeconds = max(0, Int(milliseconds / 1000))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension LyricsLineView {
    enum Layout {
        static let contentSpacing: CGFloat = 14
        static let activeLineFontSize: CGFloat = 22
        static let lineFontSize: CGFloat = 20
        static let rowHeight: CGFloat = 30
        static let seekButtonHeight: CGFloat = 26
    }
}

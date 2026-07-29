//
//  LyricsLineView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/3.
//

import SwiftUI
import Foundation

struct LyricsLineView: View {
    let line: LyricLine
    let distance: Int?
    let showsSeekControl: Bool
    let onSeek: (TimeInterval) -> Void

    @State private var isSeekControlHovering = false

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            Text(line.text.isEmpty ? " " : line.text)
                .font(.system(size: fontSize, weight: distance == 0 ? .semibold : .regular))
                .foregroundStyle(foregroundColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            if showsSeekControl {
                seekControl
            }
        }
        .frame(height: Layout.rowHeight)
    }

    private var seekControl: some View {
        Button {
            onSeek(line.time / 1000)
        } label: {
            HStack(spacing: Layout.seekControlContentSpacing) {
                Image(systemName: "play.fill")
                    .font(.system(size: Layout.seekControlIconSize, weight: .semibold))

                Text(line.time.millisecondsMinuteSecondText)
                    .font(.font13)
                    .monospacedDigit()
            }
            .foregroundStyle(seekControlTintColor)
            .padding(.horizontal, Layout.seekControlHorizontalPadding)
            .frame(height: Layout.seekControlHeight)
            .overlay {
                Capsule()
                    .stroke(seekControlTintColor, lineWidth: 1)
            }
        }
        .onHover { isSeekControlHovering = $0 }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }

    private var seekControlTintColor: Color {
        isSeekControlHovering ? .white : Color.white.opacity(0.36)
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

}

extension LyricsLineView {
    enum Layout {
        static let contentSpacing: CGFloat = 14
        static let activeLineFontSize: CGFloat = 22
        static let lineFontSize: CGFloat = 20
        static let rowHeight: CGFloat = 30
        static let seekControlHeight: CGFloat = 26
        static let seekControlContentSpacing: CGFloat = 6
        static let seekControlHorizontalPadding: CGFloat = 10
        static let seekControlIconSize: CGFloat = 8
    }
}

#Preview {
    VStack {
        LyricsLineView(
            line: .preview,
            distance: 0,
            showsSeekControl: true
        ) { _ in }

        LyricsLineView(
            line: .preview,
            distance: 1,
            showsSeekControl: false
        ) { _ in }
    }
    .frame(width: 400, height: 100)
    .background(Color(hex: 0x151515))
}

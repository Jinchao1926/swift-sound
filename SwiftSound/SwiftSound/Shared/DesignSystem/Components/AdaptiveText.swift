//
//  AdaptiveText.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

/// A single-line text view whose rendered width follows its content until `maxWidth`.
///
/// Use this when the view's own width must stay compact for short text, but long text
/// should cap at `maxWidth` and truncate with an ellipsis.
struct AdaptiveText: View {
    let text: String
    let font: Font
    let foregroundColor: Color
    let maxWidth: CGFloat

    @State private var contentWidth: CGFloat = 0

    init(
        _ text: String,
        font: Font = .font14,
        foregroundColor: Color = .textPrimary,
        maxWidth: CGFloat
    ) {
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
        self.maxWidth = maxWidth
    }

    var body: some View {
        // Text.frame(maxWidth:) creates an expandable frame. In a flexible parent, that
        // frame can grow to maxWidth even when the text is short. This component measures
        // the intrinsic text width first, then applies a concrete width capped at maxWidth.
        visibleText
            .frame(width: displayWidth, alignment: .leading)
            .background(measuringText.hidden())
            .onPreferenceChange(AdaptiveTextWidthPreferenceKey.self) { width in
                contentWidth = width
            }
    }

    private var visibleText: some View {
        Text(text)
            .font(font)
            .foregroundStyle(foregroundColor)
            .lineLimit(1)
            .truncationMode(.tail)
    }

    private var measuringText: some View {
        // Keep measurement separate from rendering. The measuring text needs fixedSize to
        // report its full intrinsic width, while the visible text must remain truncatable.
        Text(text)
            .font(font)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: AdaptiveTextWidthPreferenceKey.self, value: proxy.size.width)
                }
            )
    }

    private var displayWidth: CGFloat? {
        guard contentWidth > 0 else { return nil }
        return min(contentWidth, maxWidth)
    }
}

private struct AdaptiveTextWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    VStack(alignment: .leading) {
        AdaptiveText("短歌手", font: .font14, foregroundColor: .textSecondary, maxWidth: 185)
        AdaptiveText("这是一个很长很长的歌手名称用来验证最大宽度", font: .font14, foregroundColor: .textSecondary, maxWidth: 185)
    }
    .padding()
}

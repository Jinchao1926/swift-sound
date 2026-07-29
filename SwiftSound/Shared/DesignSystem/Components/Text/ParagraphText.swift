//
//  ParagraphText.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import SwiftUI

struct ParagraphText: View {
    let text: String
    let font: Font
    let foregroundColor: Color
    let lineSpacing: CGFloat
    let paragraphSpacing: CGFloat

    init(
        _ text: String,
        font: Font = .font13,
        foregroundColor: Color = .textSecondary,
        lineSpacing: CGFloat = 6,
        paragraphSpacing: CGFloat = 12
    ) {
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
        self.lineSpacing = lineSpacing
        self.paragraphSpacing = paragraphSpacing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: paragraphSpacing) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(verbatim: paragraph)
                    .font(font)
                    .foregroundStyle(foregroundColor)
                    .lineSpacing(lineSpacing)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var paragraphs: [String] {
        Self.splitParagraphs(text)
    }

    private static func splitParagraphs(_ text: String) -> [String] {
        let normalizedText = text.replacingOccurrences(of: "\r\n", with: "\n")
        return normalizedText
            .split(separator: "\n", omittingEmptySubsequences: true)
            .map(String.init)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

#Preview {
    ParagraphText(
        """
        第一段第一行
        第一段第二行，单个换行会显示段落间距
        第二段内容很长很长很长很长很长很长很长很长很长很长，用来验证自动换行仍然使用行间距。
        """,
        lineSpacing: 6,
        paragraphSpacing: 16
    )
    .padding()
    .frame(width: 360, alignment: .leading)
}

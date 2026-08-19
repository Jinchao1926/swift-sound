//
//  SearchBar.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    private let placeholder: String
    private let width: CGFloat

    init(
        text: Binding<String>,
        placeholder: String = "搜索",
        width: CGFloat = Layout.width
    ) {
        self._text = text
        self.placeholder = placeholder
        self.width = width
    }

    var body: some View {
        HStack(alignment: .center, spacing: Layout.controlSpacing) {
            searchIcon
            textField
            clearButton
        }
        .padding(.horizontal, Layout.horizontalInset)
        .frame(width: width, height: Layout.height)
        .roundedBackground(
            radius: Layout.cornerRadius,
            fill: Color.white.opacity(0.86),
            stroke: Color.divider.opacity(0.7)
        )
    }
}

private extension SearchBar {
    var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .font(.font13)
            .foregroundStyle(Color.textSecondary.opacity(0.72))
    }

    var textField: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .foregroundStyle(Color.textSecondary.opacity(0.55))
        )
        .textFieldStyle(.plain)
        .font(.font13)
        .foregroundStyle(Color.textPrimary)
        .lineLimit(1)
    }

    @ViewBuilder
    var clearButton: some View {
        if !text.isEmpty {
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.font11)
                    .foregroundStyle(Color.textSecondary.opacity(0.55))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("清除")
        }
    }
}

private extension SearchBar {
    enum Layout {
        static let width: CGFloat = 75
        static let height: CGFloat = 32
        static let controlSpacing: CGFloat = 5
        static let horizontalInset: CGFloat = 11
        static let cornerRadius: CGFloat = height / 2
    }
}

#Preview {
    @Previewable @State var text = ""

    SearchBar(text: $text)
        .padding()
}

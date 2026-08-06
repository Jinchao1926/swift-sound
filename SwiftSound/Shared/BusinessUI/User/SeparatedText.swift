//
//  SeparatedText.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import SwiftUI

struct SeparatedText: View {
    struct Item {
        let title: String
        let route: AppRoute?

        init(title: String, route: AppRoute? = nil) {
            self.title = title
            self.route = route
        }
    }

    private let items: [Item]
    private let separator: String
    private let font: Font
    private let foregroundStyle: Color
    private let hoverForegroundStyle: Color

    init(
        _ values: [String],
        separator: String = " / ",
        font: Font = .font13,
        foregroundStyle: Color = .textSecondary,
        hoverForegroundStyle: Color = .textPrimary
    ) {
        self.init(
            items: values.map { Item(title: $0) },
            separator: separator,
            font: font,
            foregroundStyle: foregroundStyle,
            hoverForegroundStyle: hoverForegroundStyle
        )
    }

    init(
        items: [Item],
        prefix: String? = nil,
        separator: String = " / ",
        font: Font = .font13,
        foregroundStyle: Color = .textSecondary,
        hoverForegroundStyle: Color = .textPrimary
    ) {
        self.items = items
            .map {
                Item(title: $0.title.trimmingCharacters(in: .whitespacesAndNewlines),
                     route: $0.route
                )
            }
            .filter { !$0.title.isEmpty }
        self.separator = separator
        self.font = font
        self.foregroundStyle = foregroundStyle
        self.hoverForegroundStyle = hoverForegroundStyle
    }

    var body: some View {
        if !items.isEmpty {
            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    if index > 0 {
                        Text(separator)
                    }

                    SeparatedTextItem(
                        item: item,
                        foregroundStyle: foregroundStyle,
                        hoverForegroundStyle: hoverForegroundStyle
                    )
                }
            }
            .font(font)
            .foregroundStyle(foregroundStyle)
            .lineLimit(1)
            .truncationMode(.tail)
        }
    }
}

private struct SeparatedTextItem: View {
    let item: SeparatedText.Item
    let foregroundStyle: Color
    let hoverForegroundStyle: Color

    @State private var isHovered = false

    var body: some View {
        if let route = item.route {
            label
                .onHover { isHovered = $0 }
                .routeLink(to: route)
        } else {
            label
        }
    }

    private var label: some View {
        Text(item.title)
            .foregroundStyle(isHovered ? hoverForegroundStyle : foregroundStyle)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        SeparatedText(["JJ Lin", "Wayne Lim"])
        SeparatedText([])
        SeparatedText(["一个非常非常长的艺人别名", "另一个非常非常长的艺人别名"])
        SeparatedText(
            items: [
                SeparatedText.Item(title: "陈奕迅", route: .artist(id: 2116)),
                SeparatedText.Item(title: "林俊杰", route: .artist(id: 3684))
            ],
            prefix: "歌手: "
        )
    }
    .padding()
    .environmentObject(AppRouter())
}

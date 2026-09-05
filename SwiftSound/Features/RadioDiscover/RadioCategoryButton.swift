//
//  RadioCategoryButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/5.
//

import SwiftUI

struct RadioCategoryButton: View {
    static let defaultWidth: CGFloat = 95
    static let moreWidth: CGFloat = 75
    static let height: CGFloat = 40

    enum Variant {
        case `default`
        case more
    }

    let title: String
    let variant: Variant

    @State private var isHovering = false

    init(
        _ title: String,
        variant: Variant = .default
    ) {
        self.title = title
        self.variant = variant
    }

    var body: some View {
        content
            .frame(width: variant.width, height: variant.height)
            .font(variant.font)
            .foregroundStyle(variant.foregroundColor)
            .roundedBackground(fill: backgroundColor, lineWidth: variant.borderWidth)
            .shadow(
                color: variant.shadowColor,
                radius: variant.shadowRadius,
                x: 0,
                y: variant.shadowYOffset
            )
            .contentShape(Rectangle())
            .onHover { isHovering = $0 }
            .pointerStyle(.link)
    }

    @ViewBuilder
    private var content: some View {
        if let accessorySystemImage = variant.accessorySystemImage {
            HStack(spacing: variant.accessorySpacing) {
                Text(title)
                Image(systemName: accessorySystemImage)
                    .font(variant.accessoryFont)
                    .foregroundStyle(variant.foregroundColor)
            }
        } else {
            Text(title)
        }
    }

    private var backgroundColor: Color {
        isHovering ? variant.hoverBackgroundColor : variant.backgroundColor
    }
}

private extension RadioCategoryButton.Variant {
    var width: CGFloat {
        switch self {
        case .default:
            RadioCategoryButton.defaultWidth
        case .more:
            RadioCategoryButton.moreWidth
        }
    }

    var height: CGFloat { RadioCategoryButton.height }
    var font: Font { .font16 }

    var foregroundColor: Color {
        switch self {
        case .default:
            .textPrimary.opacity(0.75)
        case .more:
            .textSecondary.opacity(0.9)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .default:
            .white
        case .more:
            Color(hex: 0xF7F9F7)
        }
    }

    var hoverBackgroundColor: Color { Color(hex: 0xE1E5E7) }
    var borderWidth: CGFloat {
        switch self {
        case .default:
            0
        case .more:
            1
        }
    }

    var shadowColor: Color {
        switch self {
        case .default:
            .black.opacity(0.08)
        case .more:
            .clear
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .default:
            2
        case .more:
            0
        }
    }

    var shadowYOffset: CGFloat {
        switch self {
        case .default:
            1
        case .more:
            0
        }
    }

    var accessorySystemImage: String? {
        switch self {
        case .default:
            nil
        case .more:
            "chevron.right"
        }
    }
    var accessorySpacing: CGFloat { 4 }
    var accessoryFont: Font { .font10 }
}

#Preview {
    HStack {
        RadioCategoryButton("排行榜")
        RadioCategoryButton("更多", variant: .more)
    }
    .padding()
    .background(Color.surfacePrimary)
}

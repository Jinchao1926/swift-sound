//
//  ActionButton.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import SwiftUI

struct ActionButton: View {
    enum Variant {
        case primary
        case secondary
    }

    let title: String?
    let systemName: String?
    let variant: Variant
    let action: () -> Void

    @State private var isHovering = false

    init(
        _ title: String? = nil,
        systemName: String? = nil,
        variant: Variant = .secondary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemName = systemName
        self.variant = variant
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Layout.iconSpacing) {
                if let systemName {
                    Image(systemName: systemName)
                        .font(.font16)
                }

                if let title {
                    Text(title)
                        .font(.font13)
                        .lineLimit(1)
                }
            }
            .foregroundStyle(variant.foregroundColor)
            .padding(.horizontal, Layout.horizontalInset)
            .fixedSize(horizontal: true, vertical: false)
            .frame(height: Layout.height)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(isHovering ? variant.hoverBackgroundColor : variant.backgroundColor)
        )
        .overlay(
            Group {
                if let borderColor = variant.borderColor {
                    RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                }
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }
}

private extension ActionButton {
    enum Layout {
        static let height: CGFloat = 37
        static let cornerRadius: CGFloat = 8
        static let horizontalInset: CGFloat = 14
        static let iconSpacing: CGFloat = 6
    }
}

private extension ActionButton.Variant {
    var foregroundColor: Color {
        switch self {
        case .primary:
            .white
        case .secondary:
            .textPrimary
        }
    }

    var backgroundColor: Color {
        switch self {
        case .primary:
            .accentPrimary
        case .secondary:
            .surfaceSecondary
        }
    }

    var hoverBackgroundColor: Color {
        switch self {
        case .primary:
            .accentPrimary.opacity(0.86)
        case .secondary:
            .surfaceHover
        }
    }

    var borderColor: Color? {
        switch self {
        case .primary:
            nil
        case .secondary:
            .divider
        }
    }
}

#Preview {
    HStack {
        ActionButton("主要操作", systemName: "star.fill", variant: .primary) {}
        ActionButton("次要操作", systemName: "gearshape") {}
    }
    .padding()
}

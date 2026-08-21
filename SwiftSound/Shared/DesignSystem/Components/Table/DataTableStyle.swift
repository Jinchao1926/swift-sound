//
//  DataTableStyle.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

struct DataTableStyle {
    let headerHeight: CGFloat
    let rowHeight: CGFloat
    let cellHorizontalPadding: CGFloat
    let cornerRadius: CGFloat
    let hoverFill: Color
    let divider: Color
    let headerForeground: Color
    let headerHoverFill: Color
    let headerCornerRadius: CGFloat

    static let plain = plain(rowHeight: 64)

    static func plain(rowHeight: CGFloat) -> DataTableStyle {
        DataTableStyle(
            headerHeight: 38,
            rowHeight: rowHeight,
            cellHorizontalPadding: 6,
            cornerRadius: 8,
            hoverFill: .white,
            divider: Color.divider.opacity(0.55),
            headerForeground: Color.textSecondary,
            headerHoverFill: Color(hex: 0xF0F1F2),
            headerCornerRadius: 6
        )
    }
}

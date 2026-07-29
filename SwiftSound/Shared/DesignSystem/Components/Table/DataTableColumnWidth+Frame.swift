//
//  DataTableColumnWidth+Frame.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/29.
//

import SwiftUI

extension View {
    @ViewBuilder
    func dataTableColumnFrame(
        _ width: DataTableColumnWidth,
        alignment: Alignment
    ) -> some View {
        switch width {
        case .fixed(let width):
            frame(width: width, alignment: alignment)
        case .flexible(let min, let ideal, let max):
            frame(
                minWidth: min,
                idealWidth: ideal,
                maxWidth: max ?? .infinity,
                alignment: alignment
            )
        }
    }
}

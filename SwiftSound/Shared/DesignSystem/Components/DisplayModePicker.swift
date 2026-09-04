//
//  DisplayModePicker.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

enum DisplayMode: CaseIterable, Hashable, Identifiable {
    case grid
    case list

    var id: Self { self }

    var imageName: String {
        switch self {
        case .grid: "square.grid.2x2"
        case .list: "list.bullet"
        }
    }
}

struct DisplayModePicker: View {
    let selection: DisplayMode
    let onSelection: (DisplayMode) -> Void

    var body: some View {
        HStack(spacing: Layout.iconSpacing) {
            ForEach(DisplayMode.allCases) { displayMode in
                IconButton(
                    systemName: displayMode.imageName,
                    font: .font16,
                    isSelected: displayMode == selection,
                    action: {
                        onSelection(displayMode)
                    }
                )
            }
        }
    }
}

private extension DisplayModePicker {
    enum Layout {
        static let iconSpacing: CGFloat = 8
    }
}

#Preview {
    DisplayModePicker(selection: .grid) { _ in }
        .padding()
}

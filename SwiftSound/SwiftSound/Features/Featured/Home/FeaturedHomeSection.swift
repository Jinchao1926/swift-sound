//
//  FeaturedHomeSectionLayout.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI
import Combine

/// Featured home section with adaptive columns capacity
struct FeaturedHomeSection<Content: View>: View {
    let columnCandidates: [Int]
    let minItemWidth: CGFloat
    let spacing: CGFloat
    @ViewBuilder let content: (Int) -> Content

    @State private var availableWidth: CGFloat = 0

    // MARK: - LifeCycle
    init(
        columnCandidates: [Int],
        minItemWidth: CGFloat,
        spacing: CGFloat = 20,
        content: @escaping (Int) -> Content
    ) {
        self.columnCandidates = columnCandidates
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        content(columns)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { newValue in
                availableWidth = newValue
            }
            .padding(.horizontal, 10)
            .padding(.top, 16)
    }
}

// MARK: - Private
private extension FeaturedHomeSection {
    var columns: Int {
        columnCandidates.first { columns in
            availableWidth >= requiredWidth(for: columns)
        } ?? columnCandidates.last ?? 1
    }

    func requiredWidth(for columns: Int) -> CGFloat {
        minItemWidth * CGFloat(columns) + spacing * CGFloat(columns - 1)
    }
}

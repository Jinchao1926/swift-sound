//
//  RadioHostChartsSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioHostChartsSection: View {
    @ObservedObject var viewModel: RadioHostChartsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            HStack(spacing: Layout.spacing) {
                ForEach(RadioHostChartType.allCases) { type in
                    SelectableCapsule(
                        type.id,
                        isSelected: viewModel.selectedType == type
                    ) {
                        viewModel.selectedType = type
                    }
                }
            }
        }
    }
}

private extension RadioHostChartsSection {
    enum Layout {
        static let spacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 20
    }
}

#Preview {
    RadioHostChartsSection(viewModel: RadioHostChartsViewModel())
}

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
            .padding(.horizontal, Layout.horizontalInset)

            ScrollView {
                RadioHostTable(hosts: viewModel.state.items)
                    .loadable(state: viewModel.state)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Layout.horizontalInset)
                    .padding(.bottom, Layout.bottomInset)
            }
            .scrollIndicatorOverlay()
        }
        .task(id: viewModel.selectedType) {
            await viewModel.load()
        }
    }
}

private extension RadioHostChartsSection {
    enum Layout {
        static let spacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 20
        static let bottomInset: CGFloat = 30
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    RadioHostChartsSection(viewModel: RadioHostChartsViewModel())
}

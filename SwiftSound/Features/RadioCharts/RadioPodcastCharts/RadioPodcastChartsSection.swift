//
//  RadioPodcastChartsSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioPodcastChartsSection: View {
    @ObservedObject var viewModel: RadioPodcastChartsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            HStack(spacing: Layout.filterSpacing) {
                ForEach(RadioPodcastChartType.allCases) { type in
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
                RadioTable(radios: viewModel.state.items)
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

private extension RadioPodcastChartsSection {
    enum Layout {
        static let filterSpacing: CGFloat = 12
        static let spacing: CGFloat = 20
        static let bottomInset: CGFloat = 30
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    RadioPodcastChartsSection(viewModel: RadioPodcastChartsViewModel())
}

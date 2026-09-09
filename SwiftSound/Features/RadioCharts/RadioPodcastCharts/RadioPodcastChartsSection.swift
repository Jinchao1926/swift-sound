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
        }
    }
}

private extension RadioPodcastChartsSection {
    enum Layout {
        static let filterSpacing: CGFloat = 12
        static let spacing: CGFloat = 20
    }
}

#Preview {
    RadioPodcastChartsSection(viewModel: RadioPodcastChartsViewModel())
}

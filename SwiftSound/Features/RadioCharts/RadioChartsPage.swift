//
//  RadioChartsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

struct RadioChartsPage: View {
    @StateObject private var viewModel = RadioChartsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            SelectableTabView(
                items: RadioChartType.allCases,
                selectedID: viewModel.selected.id,
                title: \.id
            ) { selected in
                viewModel.selected = selected
            }

            ScrollView {
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, Layout.bottomInset)
            }
            .scrollIndicatorOverlay()
        }
        .padding(.top, Layout.topInset)
        .padding(.horizontal, Layout.horizontalInset)
    }

    @ViewBuilder
    var content: some View {
        switch viewModel.selected {
        case .program:
            RadioProgramChartsSection(viewModel: viewModel.programViewModel)
        case .podcast:
            RadioPodcastChartsSection(viewModel: viewModel.podcastViewModel)
        case .host:
            RadioHostChartsSection(viewModel: viewModel.hostViewModel)
        }
    }
}

private extension RadioChartsPage {
    enum Layout {
        static let horizontalInset: CGFloat = 40
        static let topInset: CGFloat = 8
        static let bottomInset: CGFloat = 30
        static let sectionSpacing: CGFloat = 20
    }
}

#Preview {
    RadioChartsPage()
}

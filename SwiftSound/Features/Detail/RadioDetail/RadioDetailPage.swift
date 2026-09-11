//
//  RadioDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

struct RadioDetailPage: View {
    let id: Int
    let route: RadioRoute

    @StateObject private var viewModel: RadioDetailViewModel

    init(id: Int, route: RadioRoute) {
        self.id = id
        self.route = route
        self._viewModel = StateObject(wrappedValue: RadioDetailViewModel(id: id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.spacing) {
                RadioDetailHeader(
                    radio: viewModel.state.value,
                    onPlayAll: {}
                )

                RouteTabView(
                    selectedRoute: route,
                    destinationRoute: {
                        .radio(id: id, secondary: $0)
                    },
                    badgeText: tabBadgeText,
                    trailingSlot: {
                        tabTrailingSlot(for: route)
                    }
                )

                content(for: route)
            }
            .padding(.horizontal, Layout.horizontalInset)
        }
        .scrollIndicatorOverlay()
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private func content(for route: RadioRoute) -> some View {
        switch route {
        case .programs:
            RadioProgramsPage()
        case .comments:
            RadioCommentsPage()
        }
    }

    @ViewBuilder
    private func tabTrailingSlot(for route: RadioRoute) -> some View {
        if route == .programs {
            SearchBar(text: $viewModel.songSearchText)
        }
    }

    private func tabBadgeText(for route: RadioRoute) -> String? {
        switch route {
        case .programs:
            return viewModel.state.value?.programCount.formatted()
        case .comments:
            return viewModel.state.value?.commentCount?.formattedCount()
        }
    }
}

private extension RadioDetailPage {
    enum Layout {
        static let spacing: CGFloat = 10
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    RadioDetailPage(id: Radio.preview1.id, route: .programs)
}

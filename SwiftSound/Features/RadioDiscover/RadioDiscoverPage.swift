//
//  RadioDiscoverPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct RadioDiscoverPage: View {
    @StateObject private var viewModel = RadioDiscoverViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RadioCategoriesPicker(categories: viewModel.state.value ?? [])
                    .loadable(state: viewModel.state)
            }
        }
        .padding(.horizontal, Layout.horizontalInset)
        .padding(.bottom, Layout.verticalInset)
        .task {
            await viewModel.loadRadioCategories()
        }
    }
}

private extension RadioDiscoverPage {
    enum Layout {
        static let verticalInset: CGFloat = 30
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    RadioDiscoverPage()
        .environmentObject(AppRouter())
}

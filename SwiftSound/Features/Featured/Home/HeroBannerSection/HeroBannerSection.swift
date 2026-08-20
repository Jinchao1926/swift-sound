//
//  HeroBannerSection.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct HeroBannerSection: View {
    @StateObject private var viewModel = HeroBannerSectionViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Carousel(
                items: viewModel.state.items,
                configuration: CarouselConfiguration(
                    sizing: .adaptive(minimum: Layout.minCardWidth),
                    itemSpacing: Layout.cardSpacing
                )
            ) {
                BannerImageView(banner: $0)
            }
        }
        .padding(.leading, Layout.leadingInset)
        .padding(.bottom, Layout.bottomInset)
        .loadingPlaceholder(viewModel.state.isInitialLoading)
        .task {
            await viewModel.load()
        }
    }
}

private extension HeroBannerSection {
    enum Layout {
        static let minCardWidth: CGFloat = 372
        static let cardSpacing: CGFloat = 20

        static let leadingInset: CGFloat = 10
        static let bottomInset: CGFloat = 16
    }
}

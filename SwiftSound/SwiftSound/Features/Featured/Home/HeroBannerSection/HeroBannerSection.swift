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
        FeaturedHomeSection(
            columnCandidates: [3, 2],
            minItemWidth: Layout.minCardWidth
        ) { columns in
            VStack(alignment: .leading, spacing: 0) {
                Carousel(
                    items: viewModel.state.banners,
                    columns: columns,
                ) {
                    BannerImageView(banner: $0)
                }
            }
            .padding(.horizontal, 10)
            .task {
                await viewModel.load()
            }
        }
    }
}

private extension HeroBannerSection {
    enum Layout {
        static let minCardWidth: CGFloat = 380
    }
}

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
        VStack(spacing: 0) {
            switch viewModel.state {
            case let .loaded(banners):
                if !banners.isEmpty {
                    Carousel(items: banners) {
                        BannerImageView(banner: $0)
                    }
                    .frame(height: 160)
                    .padding(.horizontal, 10)
                }
            default:
                EmptyView()
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

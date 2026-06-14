//
//  HeroBanner.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct HeroBanner: View {
    @StateObject private var viewModel = HeroBannerViewModel()

    var body: some View {
        BannerCarousel(items: viewModel.banners) {
            BannerImageView(banner: $0)
        }
        .frame(height: 160)
        .padding(.horizontal, 10)
        .task {
            await viewModel.load()
        }
    }
}

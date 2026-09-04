//
//  BannerImageView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct BannerImageView: View {
    let banner: Banner

    var body: some View {
        RemoteImage(url: banner.imageURL, size: nil)
            .aspectRatio(Layout.aspectRatio, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottomTrailing) {
                Text(banner.typeTitle)
                    .font(.font9)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
                    .padding(.horizontal, Layout.textHorizontalInset)
                    .padding(.vertical, Layout.textVerticalInset)
                    .background(.white)
                    .rounded(radius: Layout.cornerRadius)
                    .padding(Layout.textInset)
            }
            .rounded()
    }
}

private extension BannerImageView {
    enum Layout {
        static let aspectRatio: CGFloat = 19 / 7
        static let textHorizontalInset: CGFloat = 4
        static let textVerticalInset: CGFloat = 4
        static let cornerRadius: CGFloat = 4
        static let textInset: CGFloat = 10
    }
}

#Preview {
    BannerImageView(banner: .preview)
        .frame(width: 380, height: 140)
        .padding()
}

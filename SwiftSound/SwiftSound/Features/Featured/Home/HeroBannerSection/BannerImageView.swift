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
        ZStack(alignment: .bottomTrailing) {
            RemoteImage(url: URL(string: banner.imageUrl))

            Text(banner.typeTitle)
                .font(.font9)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(10)
        }
    }
}

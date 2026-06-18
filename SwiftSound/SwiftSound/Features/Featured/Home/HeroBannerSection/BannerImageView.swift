//
//  BannerImageView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct BannerImageView: View {
    let banner: Banner

    @State private var width: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RemoteImage(url: URL(string: banner.imageUrl))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

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
        .frame(height: height)
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { newValue in
            width = newValue
        }
    }

    private var height: CGFloat? {
        guard width > 0 else { return nil }
        return width * Layout.heightRatio
    }
}

private extension BannerImageView {
    enum Layout {
        static let heightRatio: CGFloat = 7 / 19
    }
}

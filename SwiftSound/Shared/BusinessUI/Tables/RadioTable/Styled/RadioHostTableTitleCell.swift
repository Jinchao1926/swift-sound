//
//  RadioHostTableTitleCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioHostTableTitleCell: View {
    let imageURL: URL?
    let title: String

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            Avatar(url: imageURL, size: Layout.imageSize)

            Text(title)
                .font(.font14)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.trailing, Layout.trailingPadding)
    }
}

private enum Layout {
    static let contentSpacing: CGFloat = 10
    static let trailingPadding: CGFloat = 30

    static let imageSize: CGFloat = 38
    static let imageCornerRadius: CGFloat = 4
}

#Preview {
    VStack {
        RadioHostTableTitleCell(
            imageURL: RadioHost.preview.imageURL,
            title: RadioHost.preview.nickName
        )

        RadioHostTableTitleCell(
            imageURL: RadioHost.preview1.imageURL,
            title: RadioHost.preview1.nickName
        )
    }
    .padding()
    .frame(width: 360)
    .background(Color.surfacePrimary)
}

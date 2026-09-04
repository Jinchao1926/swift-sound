//
//  AlbumProfilePage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/30.
//

import SwiftUI

struct AlbumProfilePage: View {
    let description: String?

    var body: some View {
        if let description {
            VStack(alignment: .leading, spacing: Layout.verticalInset) {
                Text("专辑简介")
                    .font(.font16)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.top, Layout.titleTopInset)

                ParagraphText(
                    description,
                    lineSpacing: Layout.paragraphLineSpacing,
                    paragraphSpacing: Layout.paragraphSpacing
                )
                .padding(.bottom, Layout.paragraphBottomInset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } else {
            EmptyStateView()
        }
    }
}

private extension AlbumProfilePage {
    enum Layout {
        static let verticalInset: CGFloat = 20
        static let titleTopInset: CGFloat = 5

        static let paragraphLineSpacing: CGFloat = 10
        static let paragraphSpacing: CGFloat = 20
        static let paragraphBottomInset: CGFloat = 50
    }
}

#Preview {
    VStack {
        AlbumProfilePage(description: Album.preview.description)
        Divider()
        AlbumProfilePage(description: nil)
    }
    .frame(width: 500, height: 500)
}

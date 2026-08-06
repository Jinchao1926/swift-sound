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
        VStack(alignment: .leading, spacing: Layout.verticalInset) {
            Text("专辑简介")
                .font(.font16)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textSecondary)
                .padding(.top, Layout.titleTopInset)

            ParagraphText(
                description ?? "",
                lineSpacing: Layout.paragraphLineSpacing,
                paragraphSpacing: Layout.paragraphSpacing
            )
            .padding(.bottom, Layout.paragraphBottomInset)
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
    AlbumProfilePage(description: Album.preview.description)
}

//
//  ArtistProfilePage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/24.
//

import SwiftUI

struct ArtistProfilePage: View {
    let name: String?
    let state: Loadable<ArtistDesc>
    let load: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            head("\(name ?? "")简介")
            ParagraphText(
                state.briefDesc,
                lineSpacing: Layout.paragraphLineSpacing,
                paragraphSpacing: Layout.paragraphSpacing
            )
            .padding(.bottom, Layout.paragraphBottomInset)

            ForEach(state.introduction, id: \.ti) {
                head($0.ti)
                ParagraphText(
                    $0.txt,
                    lineSpacing: Layout.paragraphLineSpacing,
                    paragraphSpacing: Layout.paragraphSpacing
                )
                .padding(.bottom, Layout.paragraphBottomInset)
            }
        }
        .padding(.vertical, Layout.verticalInset)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .task {
            await load()
        }
    }

    private func head(_ text: String) -> some View {
        Text(text)
            .font(.font16)
            .fontWeight(.semibold)
            .foregroundStyle(Color.textPrimary)
            .padding(.bottom, Layout.verticalInset)
    }
}

private extension ArtistProfilePage {
    enum Layout {
        static let verticalInset: CGFloat = 20

        static let paragraphLineSpacing: CGFloat = 10
        static let paragraphSpacing: CGFloat = 20
        static let paragraphBottomInset: CGFloat = 30
    }
}

#Preview {
    ScrollView {
        ArtistProfilePage(
            name: Artist.preview.name,
            state: .loaded(
                ArtistDesc(
                    introduction: [
                        ArtistIntroduction(
                            ti: "从艺经历",
                            txt: "第一段内容\n第二段内容，单个换行会显示段落间距。"
                        )
                    ],
                    briefDesc: "简介第一段\n简介第二段",
                )
            ),
            load: {}
        )
    }
    .frame(width: 800, height: 600)
}

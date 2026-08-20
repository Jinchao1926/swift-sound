//
//  MVDetailPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import SwiftUI

struct MVDetailPage: View {
    let id: Int

    @StateObject private var viewModel: MVDetailViewModel

    init(id: Int) {
        self.id = id
        self._viewModel = StateObject(wrappedValue: MVDetailViewModel(id: id))
    }

    var body: some View {
        ScrollView {
            Group {
                if let mv = viewModel.state.value {
                    VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                        MVVideoPlayer(
                            player: viewModel.player,
                            error: viewModel.urlState.error
                        )

                        Text(mv.name)
                            .font(.font20)
                            .foregroundStyle(Color.textPrimary)

                        artistInfo(for: mv)
                        metadataRow(for: mv)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, Layout.inset)
            .padding(.bottom, Layout.inset)
        }
        .scrollIndicatorsWhileScrolling()
        .task {
            await viewModel.loadMV()
        }
        .onDisappear {
            viewModel.stopPlayer()
        }
    }
}

private extension MVDetailPage {
    func artistInfo(for mv: MVDetail) -> some View {
        HStack(spacing: Layout.artistSpacing) {
            if mv.artists.count > 1 {
                Text("歌手:")
                    .font(.font14)
                    .foregroundStyle(Color.textPrimary)

                SeparatedText(
                    items: mv.artists.map {
                        SeparatedText.Item(title: $0.name, route: .artist(id: $0.id))
                    },
                    font: .font14
                )
            } else {
                Avatar(url: mv.artists.first?.avatarURL, size: Layout.artistAvatarSize)
                    .routeLink(to: .artist(id: mv.artistId))

                Text(mv.artistName)
                    .font(.font14)
                    .foregroundStyle(Color.textSecondary)

                RoundedButton(
                    "+ 关注",
                    font: .font13,
                    width: Layout.followButtonWidth,
                    height: Layout.followButtonHeight
                ) {}
            }

            Spacer(minLength: 0)
        }
    }

    func metadataRow(for mv: MVDetail) -> some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(spacing: Layout.metadataSpacing) {
                Text("发布时间:  \(mv.publishTime)")
                Text("播放:  \(mv.playCount)")
            }

            Spacer()

            HStack(spacing: Layout.actionSpacing) {
                HStack(spacing: 0) {
                    Text(mv.subCount.formattedCount())
                    metadataButton("hand.thumbsup")
                }
                metadataButton("plus.square")
                metadataButton("arrowshape.turn.up.right")
                Button("举报") {}
                    .buttonStyle(.plain)
                    .pointerStyle(.link)
            }
        }
        .font(.font13)
        .foregroundStyle(Color.textTertiary)
    }

    func metadataButton(_ systemName: String) -> IconButton {
        IconButton(
            systemName: systemName,
            font: .font20,
            size: Layout.actionIconSize
        )
    }
}

private extension MVDetailPage {
    enum Layout {
        static let inset: CGFloat = 40
        static let sectionSpacing: CGFloat = 25

        static let artistSpacing: CGFloat = 14
        static let artistAvatarSize: CGFloat = 42
        static let followButtonWidth: CGFloat = 66
        static let followButtonHeight: CGFloat = 20

        static let metadataSpacing: CGFloat = 20
        static let actionSpacing: CGFloat = 15
        static let actionIconSize: CGFloat = 28

    }
}

#Preview {
    MVDetailPage(id: MV.preview.id)
        .frame(minWidth: 600, minHeight: 800)
}

//
//  RankingCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

struct RankingCard: View {
    enum Variant {
        case `default`
        case title
        case flag(String)
    }

    let toplist: Toplist
    let category: RankingCategory
    let variant: Variant
    let onPlay: (() -> Void)?

    @State private var isHovering = false

    init(
        toplist: Toplist,
        category: RankingCategory = .featured,
        variant: Variant = .default,
        onPlay: (() -> Void)? = nil
    ) {
        self.toplist = toplist
        self.category = category
        self.variant = variant
        self.onPlay = onPlay
    }

    var body: some View {
        ZStack {
            RemoteImage(url: URL(string: toplist.coverImgUrl))
                .frame(width: Layout.size, height: Layout.size)

            overlay

            if isHovering {
                Color.black.opacity(0.28)

                playButton
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(Layout.playButtonMargin)
            }
        }
        .frame(width: Layout.size, height: Layout.size)
        .rounded(radius: Layout.cornerRadius)
        .routeLink(to: .featured())
        .onHover { isHovering = $0 }
    }
}

private extension RankingCard {
    @ViewBuilder
    var overlay: some View {
        switch variant {
        case .default:
            EmptyView()
        case .title:
            Text(category.displayTitle(for: toplist))
                .font(.font14.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.top, Layout.titleTopPadding)
                .padding(.horizontal, Layout.titleHorizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

        case .flag(let flag):
            Text(flag)
                .font(.system(size: Layout.flagSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(Layout.flagPadding)
        }
    }

    var playButton: some View {
        Button {
            onPlay?()
        } label: {
            PlaybackControlIcon(
                control: .play,
                font: .font24,
                size: Layout.playIconSize,
                animatesHoverEffects: true
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Ranking cards") {
    HStack(spacing: 16) {
        RankingCard(toplist: .defaultPreview)
        RankingCard(toplist: .titlePreview, variant: .title)
        RankingCard(toplist: .flagPreview, variant: .flag("🇺🇸"))
    }
    .padding()
}

private extension RankingCard {
    enum Layout {
        static let size: CGFloat = 115
        static let cornerRadius: CGFloat = 6

        static let playButtonMargin: CGFloat = 15
        static let playIconSize: CGFloat = 24

        static let titleTopPadding: CGFloat = 20
        static let titleHorizontalPadding: CGFloat = 5
        static let flagSize: CGFloat = 17
        static let flagPadding: CGFloat = 8
    }
}

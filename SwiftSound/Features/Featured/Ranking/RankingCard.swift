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
        RemoteImage(url: toplist.imageURL)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .overlay {
                flagOverlay
            }
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.playbackButtonInset),
                    buttonSize: Layout.playbackIconSize,
                    iconFont: .font24
                ),
                onPlaybackTap: onPlay
            )
            .rounded()
    }
}

private extension RankingCard {
    @ViewBuilder
    var flagOverlay: some View {
        switch variant {
        case .default:
            EmptyView()
        case .title:
            Text(category.displayTitle(for: toplist))
                .font(.font14.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.top, Layout.titleTopInset)
                .padding(.horizontal, Layout.titleHorizontalInset)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

        case .flag(let flag):
            Text(flag)
                .font(.system(size: Layout.flagSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(Layout.flagInset)
        }
    }
}

#Preview("Ranking cards") {
    HStack(spacing: 16) {
        RankingCard(toplist: .defaultPreview) {}
            .frame(width: 115)
        RankingCard(toplist: .titlePreview, variant: .title) {}
            .frame(width: 115)
        RankingCard(toplist: .flagPreview, variant: .flag("🇺🇸")) {}
            .frame(width: 115)
    }
    .padding()
}

private extension RankingCard {
    enum Layout {
        static let playbackButtonInset: CGFloat = 15
        static let playbackIconSize: CGFloat = 24
        static let titleTopInset: CGFloat = 20
        static let titleHorizontalInset: CGFloat = 5
        static let flagSize: CGFloat = 17
        static let flagInset: CGFloat = 8
    }
}

//
//  RankingListPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct RankingListPage: View {
    @StateObject private var viewModel = RankingListViewModel()

    var body: some View {
        LazyVStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            ForEach(viewModel.state.items) { section in
                RankingSectionView(section: section)
            }
        }
        .padding(.top, Layout.topInset)
        .padding(.bottom, Layout.inset)
        .padding(.horizontal, Layout.inset)
        .loadingPlaceholder(viewModel.state.isInitialLoading)
        .task {
            await viewModel.load()
        }
    }
}

private extension RankingListPage {
    enum Layout {
        static let topInset: CGFloat = 3
        static let inset: CGFloat = 40
        static let sectionSpacing: CGFloat = 32
    }
}

private struct RankingSectionView: View {
    let section: RankingSection

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            Text(section.title)
                .font(.font16.weight(.semibold))
                .foregroundStyle(Color.textPrimary)

            if section.category == .official {
                officialCards
            } else {
                smallCards
            }
        }
    }
}

private extension RankingSectionView {
    var officialCards: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: Layout.officialMinimumWidth), spacing: Layout.cardSpacing)
            ],
            alignment: .leading,
            spacing: Layout.cardSpacing
        ) {
            ForEach(section.toplists) {
                OfficialRankingCard(toplist: $0)
                    .routeLink(to: .playlist(id: $0.id))
            }
        }
    }

    var smallCards: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: Layout.smallCardMinimumWidth),
                    spacing: Layout.cardSpacing,
                    alignment: .leading
                )
            ],
            alignment: .leading,
            spacing: Layout.cardSpacing
        ) {
            ForEach(section.toplists) {
                RankingCard(
                    toplist: $0,
                    category: section.category,
                    variant: cardVariant(for: $0)
                )
                .routeLink(to: .playlist(id: $0.id))
            }
        }
    }
}

private extension RankingSectionView {
    func cardVariant(for toplist: Toplist) -> RankingCard.Variant {
        switch section.category {
        case .global:
            return .title
        case .language:
            return .flag(flag(for: toplist.id))
        case .recommendation:
            switch toplist.id {
            case 2_809_513_713:
                return .flag("🇺🇸")
            case 745_956_260:
                return .flag("🇰🇷")
            default:
                return .default
            }
        case .official, .featured, .genre, .special:
            return .default
        }
    }

    func flag(for toplistID: Int) -> String {
        switch toplistID {
        case 2_809_513_713, 2_809_577_409:
            return "🇺🇸"
        case 5_059_644_681:
            return "🇯🇵"
        case 745_956_260:
            return "🇰🇷"
        case 6_732_051_320:
            return "🇷🇺"
        case 7_095_271_308:
            return "🇹🇭"
        case 6_732_014_811:
            return "🇻🇳"
        default:
            return ""
        }
    }
}

private extension RankingSectionView {
    enum Layout {
        static let spacing: CGFloat = 12
        static let cardSpacing: CGFloat = 15
        static let smallCardMinimumWidth: CGFloat = 115
        static let officialMinimumWidth: CGFloat = 378
    }
}

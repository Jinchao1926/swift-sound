//
//  OfficialRankingCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

struct OfficialRankingCard: View {
    let toplist: Toplist

    var body: some View {
        VStack(spacing: Layout.topSpacing) {
            HStack(alignment: .top) {
                Text(displayTitle)
                    .font(.font16.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Spacer()
                Text(toplist.updateFrequency)
                    .font(.font12)
                    .foregroundStyle(Color(hex: 0xCACBCD))
                    .lineLimit(1)
            }

            HStack(spacing: Layout.spacing) {
                coverImageStack

                VStack(alignment: .leading, spacing: Layout.trackSpacing) {
                    ForEach(Array(toplist.tracks ?? []).enumerated(), id: \.offset) { index, track in
                        HStack(spacing: Layout.spacing) {
                            Text("\(index + 1)")
                                .font(.font16.weight(.semibold))
                                .foregroundStyle(Color.textPrimary)

                            Text(trackContent(for: track))
                                .font(.font14)
                                .lineLimit(1)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.top, Layout.topSpacing)
        .padding(.bottom, Layout.spacing)
        .padding(.horizontal, Layout.spacing)
        .background(Color.white)
        .rounded()
    }
}

private extension OfficialRankingCard {
    var coverImageStack: some View {
        ZStack(alignment: .topLeading) {
            stackedRemoteImage(offset: Layout.imageLayerOffset * 2, opacity: 0.2)
            stackedRemoteImage(offset: Layout.imageLayerOffset, opacity: 0.4)
            RemoteImage(url: toplist.imageURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .playbackOverlay(
                    configuration: .init(
                        buttonSize: Layout.playButtonSize,
                        iconFont: .font24
                    ),
                    onPlaybackTap: {}
                )
                .rounded()
        }
        .frame(
            width: Layout.imageSize + Layout.imageLayerOffset * 2,
            height: Layout.imageSize,
            alignment: .topLeading
        )
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
    }

    func stackedRemoteImage(offset: CGFloat, opacity: Double) -> some View {
        RemoteImage(url: toplist.imageURL)
            .frame(width: Layout.imageSize, height: Layout.imageSize)
            .frame(
                width: Layout.imageSize,
                height: Layout.imageSize - offset,
                alignment: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .offset(x: offset, y: offset)
            .opacity(opacity)
            .allowsHitTesting(false)
    }
}

private extension OfficialRankingCard {
    func trackContent(for track: ToplistSong) -> AttributedString {
        var content = AttributedString(track.first)
        content.foregroundColor = Color.textPrimary

        var artistContent = AttributedString(" - \(track.second)")
        artistContent.foregroundColor = Color.textSecondary
        return content + artistContent
    }

    var displayTitle: String {
        switch toplist.id {
        case 1_9723_756:
            return "飙升榜"
        case 3_779_629:
            return "新歌榜"
        case 2_884_035:
            return "原创榜"
        case 3_778_678:
            return "热歌榜"
        default:
            return toplist.name.replacingOccurrences(of: "网易云", with: "")
        }
    }
}

private extension OfficialRankingCard {
    enum Layout {
        static let cornerRadius: CGFloat = 6
        static let topSpacing: CGFloat = 17
        static let spacing: CGFloat = 20

        static let imageSize: CGFloat = 72
        static let playButtonSize: CGFloat = 24
        static let imageLayerOffset: CGFloat = 8
        static let trackSpacing: CGFloat = 8
    }
}

#Preview {
    VStack {
        OfficialRankingCard(toplist: .officialRankingPreview)
    }
    .padding()
    .background(Color.surfacePrimary)
}

//
//  PlaylistCover.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct PlaylistCover: View {
    let playlist: Playlist

    @State private var isHovering = false

    var body: some View {
        GeometryReader { proxy in
            let cardWidth = proxy.size.width
            let cardHeight = cardWidth + Layout.bottomPanelHeight

            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    RemoteImage(url: URL(string: playlist.coverImgUrl))
                        .frame(width: cardWidth, height: cardWidth)

                    Color.clear
                        .frame(width: cardWidth, height: Layout.bottomPanelHeight)
                }

                PlayCountBadge(count: playlist.playCount)
                    .padding(Layout.inset)

                PlaylistCoverBottomPanel(
                    title: playlist.name,
                    tracks: tracks,
                    panelColor: panelColor,
                    isHovering: isHovering
                )
                .frame(width: cardWidth, height: isHovering ? cardHeight : Layout.bottomPanelHeight)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .pointerStyle(.link)
            .onHover { isHovering = $0 }
            .animation(.easeInOut(duration: 0.18), value: isHovering)
        }
    }
}

// MARK: - Private
fileprivate extension PlaylistCover {
    enum Layout {
        static let inset: CGFloat = 10
        static let bottomPanelHeight: CGFloat = 58
    }

//    var tracks: [Track] {
//        Array((playlist.tracks ?? []).prefix(3))
//    }

    struct TrackData {
        let id: Int
        let name: String
    }
    var tracks: [TrackData] {
        [.init(id: 1, name: "我怀念的"), .init(id: 2, name: "爱我还是他"), .init(id: 3, name: "江南")]
    }

    var panelColor: Color {
        Color(hex: 0xA55E76)
    }
}

private struct PlaylistCoverBottomPanel: View {
    let title: String
    let tracks: [PlaylistCover.TrackData]
    let panelColor: Color
    let isHovering: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            background

            VStack(alignment: .leading, spacing: 0) {
                if isHovering {
                    Spacer()
                }

                titleView

                if isHovering {
                    HStack(alignment: .bottom, spacing: Layout.inset) {
                        PlaylistCoverTrackList(tracks: tracks)
                        Spacer(minLength: Layout.inset)
                        PlayButton()
                    }
                    .padding(.horizontal, Layout.inset)
                    .padding(.bottom, Layout.tracksVerticalInset)
                    .padding(.top, Layout.tracksVerticalInset - Layout.inset)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

private extension PlaylistCoverBottomPanel {
    enum Layout {
        static let inset: CGFloat = 10
        static let tracksVerticalInset: CGFloat = 15
    }

    var titleView: some View {
        Text(title)
            .font(.font13.weight(.semibold))
            .foregroundStyle(.white)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .lineSpacing(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Layout.inset)
    }

    var background: some View {
        LinearGradient(
            stops: [
                .init(color: panelColor, location: 0),
                .init(color: panelColor, location: 0.5),
                .init(color: panelColor.opacity(isHovering ? 0.52 : 1), location: 0.78),
                .init(color: panelColor.opacity(isHovering ? 0 : 1), location: 1)
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

private struct PlaylistCoverTrackList: View {
    let tracks: [PlaylistCover.TrackData]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(tracks.enumerated()), id: \.element.id) { index, track in
                Text("\(index + 1) \(track.name)")
                    .font(.font13.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}

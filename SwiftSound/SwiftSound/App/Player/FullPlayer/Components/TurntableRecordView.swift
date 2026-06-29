//
//  TurntableRecordView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/29.
//

import SwiftUI

struct TurntableRecordView: View {
    static let width: CGFloat = Layout.outerRecordSize

    let song: Song
    let playbackState: PlaybackState

    init(song: Song, playbackState: PlaybackState = .stopped) {
        self.song = song
        self.playbackState = playbackState
    }

    var body: some View {
        ZStack(alignment: .top) {
            pointer
                .offset(x: Layout.pointerOffsetX)
                .zIndex(2)

            record
                .padding(.top, Layout.recordTopInset)
                .zIndex(1)
        }
        .frame(
            width: Layout.outerRecordSize,
            height: Layout.containerHeight,
            alignment: .top
        )
    }

    private var pointer: some View {
        Image("pointer")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: Layout.pointerWidth)
            .rotationEffect(pointerRotation, anchor: Layout.pointerPivot)
            .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 5)
            .animation(.easeInOut(duration: 0.6), value: playbackState.isPlaybackActive)
    }

    private var record: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))

            SongCoverImage(song: song, variant: .large)
        }
        .frame(width: Layout.outerRecordSize, height: Layout.outerRecordSize)
        .shadow(color: Color.black.opacity(0.42), radius: 18, x: 0, y: 18)
    }

    private enum Layout {
        static let recordInset: CGFloat = 15
        static let coverSize: CGFloat = 310
        static let outerRecordSize: CGFloat = coverSize + recordInset * 2

        static let pointerWidth: CGFloat = 180
        static let pointerOffsetX: CGFloat = (outerRecordSize - pointerWidth) / 2
        static let recordTopInset: CGFloat = 85
        static let containerHeight: CGFloat = 425

        static let pointerPivot = UnitPoint(x: 0.1, y: 0.19)
        static let idlePointerAngle: Angle = .degrees(0)
        static let activePointerAngle: Angle = .degrees(38)
    }
}

private extension TurntableRecordView {
    private var pointerRotation: Angle {
        playbackState.isPlaybackActive ? Layout.activePointerAngle : Layout.idlePointerAngle
    }
}

#Preview {
    VStack(spacing: 40) {
        TurntableRecordView(song: .preview, playbackState: .paused)

        TurntableRecordView(song: .preview, playbackState: .playing)
    }
    .background(Color(hex: 0x151515))
}

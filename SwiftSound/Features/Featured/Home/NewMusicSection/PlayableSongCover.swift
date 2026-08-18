//
//  PlayableSongCover.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/18.
//

import SwiftUI

struct PlayableSongCover: View {
    let url: URL?
    let controlIcon: PlaybackControl
    let isCurrent: Bool
    let isHovering: Bool
    let onPlay: () -> Void

    init(
        url: URL? = nil,
        controlIcon: PlaybackControl = .play,
        isCurrent: Bool = false,
        isHovering: Bool = false,
        onPlay: @escaping () -> Void
    ) {
        self.url = url
        self.controlIcon = controlIcon
        self.isCurrent = isCurrent
        self.isHovering = isHovering
        self.onPlay = onPlay
    }

    var body: some View {
        RemoteImage(url: url)
            .frame(width: 50, height: 50)
            .playbackOverlay(
                configuration: .init(
                    visibility: isCurrent ? .always : .onHover,
                    control: controlIcon,
                    tapTarget: .content,
                    buttonSize: 24,
                    iconFont: .font20
                ),
                isExternalHovering: isHovering,
                onPlaybackTap: onPlay
            )
            .rounded()
    }
}

#Preview {
    @Previewable @State var isHovering = false

    VStack {
        PlayableSongCover(isHovering: isHovering) {
            // ...
        }
    }
    .padding()
    .onHover { isHovering = $0 }
}

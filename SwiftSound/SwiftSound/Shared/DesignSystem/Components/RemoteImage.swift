//
//  RemoteImage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Kingfisher
import SwiftUI

struct RemoteImage: View {
    let url: URL?
    let contentMode: SwiftUI.ContentMode

    init(
        url: URL?,
        contentMode: SwiftUI.ContentMode = .fill
    ) {
        self.url = url?.httpsURL
        self.contentMode = contentMode
    }

    var body: some View {
        KFImage(url)
            .placeholder {
                Color.surfaceSecondary
            }
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

private extension URL {
    var httpsURL: URL {
        guard scheme == "http", var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }

        components.scheme = "https"
        return components.url ?? self
    }
}

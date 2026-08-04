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
        size: Int? = 200,
        contentMode: SwiftUI.ContentMode = .fill
    ) {
        self.url = url?.httpsURL.sizedImageURL(size)
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

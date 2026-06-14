//
//  HeroBanner.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct BannerItem: Identifiable {
    let url: URL

    var id: URL { url }
}

struct HeroBanner: View {
    let banners = [
        "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80828520132/09b3/779a/ace1/476b948f76185603ccac946914cf26bc.jpg?imageView&quality=89",
        "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80829909793/8ee4/adaa/8823/3e9fb1236d4f5824f4b74bc8124b81e7.jpg?imageView&quality=89",
        "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/76565271521/523c/9ac1/3a18/8cc1b2fa00061da019ede6f755ce8678.jpg?imageView&quality=89",
        "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80533342370/a726/8dbb/fbf9/ad9791e64eadd94839b2b88fb445d0c3.jpg?imageView&quality=89",
        "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80855126814/3e77/0ca1/ffe1/9560caf557ac4bf94bdc81f9526345f9.jpg?imageView&quality=89",
        "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80782189746/3aca/04bb/d55d/e594bd14a5700ca7567035e7235ed637.jpg?imageView&quality=89"
    ].compactMap { URL(string: $0).map(BannerItem.init(url:)) }

    var body: some View {
        BannerCarousel(items: banners) { item in
            RemoteImage(url: item.url)
        }
        .frame(height: 160)
        .padding(.horizontal, 10)
    }
}

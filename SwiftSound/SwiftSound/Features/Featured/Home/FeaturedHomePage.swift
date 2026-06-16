//
//  FeaturedHomePage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct FeaturedHomePage: View {
    var body: some View {
        HeroBanners()
        OfficialPlaylists()
        LatestMusic()
    }
}

#Preview {
    FeaturedHomePage()
        .frame(minWidth: 700, minHeight: 300)
}

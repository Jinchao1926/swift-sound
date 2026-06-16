//
//  LatestMusic.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct LatestMusic: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RouteTitleLink("最新音乐", route: AppRoute.latestMusic())
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.top, 16)
    }
}

#Preview {
    LatestMusic()
        .frame(minWidth: 600, minHeight: 300)
}

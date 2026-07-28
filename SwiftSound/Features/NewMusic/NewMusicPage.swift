//
//  NewMusicPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import SwiftUI

struct NewMusicPage: View {
    let route: NewMusicRoute

    var body: some View {
        VStack(spacing: 10) {
            RouteTabView(selectedRoute: route)
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch route {
        case .songs:
            NewSongsPage()
        case .albums:
            NewAlbumsPage()
        }
    }
}

#Preview {
    NewMusicPage(route: .songs)
        .environmentObject(AppRouter())
}

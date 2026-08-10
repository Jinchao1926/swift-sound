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
        .padding(.bottom, Layout.bottomPadding)
        .padding(.horizontal, Layout.horizontalPadding)
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

private extension NewMusicPage {
    enum Layout {
        static let bottomPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 40
    }
}

#Preview {
    NewMusicPage(route: .songs)
        .environmentObject(AppRouter())
}

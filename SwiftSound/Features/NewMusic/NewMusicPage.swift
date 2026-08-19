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
        .padding(.bottom, Layout.bottomInset)
        .padding(.horizontal, Layout.horizontalInset)
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
        static let bottomInset: CGFloat = 20
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    NewMusicPage(route: .songs)
        .environmentObject(AppRouter())
}

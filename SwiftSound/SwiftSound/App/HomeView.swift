//
//  HomeView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var playerStore = PlayerStore()

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SidebarView()
                    .frame(width: 203)

                DetailContainerView()
                    .frame(minWidth: 854, maxWidth: .infinity)
            }

            if playerStore.state.currentIndex != nil {
                PlayerBarView()
            }
        }
        .frame(minHeight: 720)
        .environmentObject(router)
        .environmentObject(playerStore)
    }
}

#Preview {
    HomeView()
}

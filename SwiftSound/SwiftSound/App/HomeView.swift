//
//  HomeView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI
import AppKit

struct HomeView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var playerStore = PlayerStore()
    @State private var isPlayerPresented = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    SidebarView()
                        .frame(width: 203)

                    DetailContainerView()
                        .frame(minWidth: 854, maxWidth: .infinity)
                }

                if let playerBarModel = PlayerBarModel(state: playerStore.state) {
                    PlayerBarView(
                        model: playerBarModel,
                        callback: playerBarCallback,
                        onActivate: {
                            withAnimation(.easeInOut(duration: 0.22)) {
                                isPlayerPresented = true
                            }
                        }
                    )
                }
            }

            if isPlayerPresented, let playerBarModel = PlayerBarModel(state: playerStore.state) {
                PlayerView(
                    model: playerBarModel,
                    callback: playerBarCallback,
                    onCollapse: {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            isPlayerPresented = false
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .frame(minHeight: 720)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
            playerStore.flushPersistence()
        }
        .environmentObject(router)
        .environmentObject(playerStore)
    }

    private var playerBarCallback: PlayerBarCallback {
        PlayerBarCallback(
            onTogglePlayPause: {
                playerStore.send(.togglePlayPause)
            },
            onPrevious: {
                playerStore.send(.previous)
            },
            onNext: {
                playerStore.send(.next)
            },
            onSeek: {
                playerStore.send(.seek(to: $0))
            },
            onCyclePlaybackMode: {
                playerStore.send(.cyclePlaybackMode)
            }
        )
    }
}

#Preview {
    HomeView()
}

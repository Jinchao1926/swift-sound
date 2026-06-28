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

                if let playerBarModel = PlayerPresentationModel(state: playerStore.state) {
                    PlayerBarView(
                        model: playerBarModel,
                        callback: playerCallback,
                        onActivate: {
                            withAnimation(.easeInOut(duration: 0.22)) {
                                isPlayerPresented = true
                            }
                        }
                    )
                }
            }

            if isPlayerPresented, let playerModel = PlayerPresentationModel(state: playerStore.state) {
                FullPlayerView(
                    model: playerModel,
                    callback: playerCallback,
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

    private var playerCallback: PlayerControlsCallback {
        PlayerControlsCallback(
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
            },
            onSetVolume: {
                playerStore.send(.setVolume($0))
            },
            onToggleMute: {
                playerStore.send(.toggleMute)
            }
        )
    }
}

#Preview {
    HomeView()
}

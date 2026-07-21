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
    @StateObject private var lyricsStore = LyricsStore()
    @State private var isPlayerPresented = false
    @State private var isPlaylistPresented = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
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
                        },
                        onTogglePlaylist: togglePlaylist
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
                    },
                    onTogglePlaylist: togglePlaylist
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }

            if isPlaylistPresented {
                PlayerPlaylistOverlayContainerView(onDismiss: hidePlaylist)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(2)
            }
        }
        .frame(minHeight: 720)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
            playerStore.flushPersistence()
        }
        .environmentObject(router)
        .environmentObject(playerStore)
        .environmentObject(lyricsStore)
    }

    private func togglePlaylist() {
        withAnimation(.easeInOut(duration: 0.22)) {
            isPlaylistPresented.toggle()
        }
    }

    private func hidePlaylist() {
        withAnimation(.easeInOut(duration: 0.22)) {
            isPlaylistPresented = false
        }
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
            onSeekAndPlay: {
                playerStore.send(.seek(to: $0))
                playerStore.send(.play)
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

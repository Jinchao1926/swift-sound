//
//  PlaylistDiscoveryPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import SwiftUI

struct PlaylistDiscoveryPage: View {
    @StateObject private var viewModel = PlaylistDiscoveryViewModel()
    @State private var selection: PlaylistDiscoverySelection = .recommendation

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.contentSpacing) {
            PlaylistDiscoveryCategoryBar(
                categoryGroups: viewModel.state.value ?? [],
                selection: $selection
            )
            Spacer()
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.topPadding)
        .task {
            await viewModel.load()
        }
    }
}

private extension PlaylistDiscoveryPage {
    enum Layout {
        static let topPadding: CGFloat = 3
        static let horizontalPadding: CGFloat = 40
        static let contentSpacing: CGFloat = 25
    }
}

#Preview {
    PlaylistDiscoveryPage()
}

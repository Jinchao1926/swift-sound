//
//  UserRadiosPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import SwiftUI

struct UserRadiosPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.tabContentSpacing) {
            HStack(spacing: 0) {
                Text("Ta创建的播客")
                    .font(.font18.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                HStack(spacing: Layout.iconSpacing) {
                    ForEach(PlaylistDisplayMode.allCases) { displayMode in
                        IconButton(
                            systemName: displayMode.imageName,
                            font: .font16,
                            isSelected: displayMode == selection.displayMode,
                            action: {
                                onAction(.displayMode(displayMode))
                            }
                        )
                    }
                }
            }
            
            UserRadioSection(
                collection: viewModel.selectedPlaylists,
                displayMode: viewModel.playlistSelection.displayMode,
                onPageChange: load
            )
        }
        .padding(.top, Layout.contentTopInset)
        .padding(.bottom, Layout.contentBottomInset)
    }
}

private extension UserRadiosPage {
    enum Layout {
        static let contentTopInset: CGFloat = 10
        static let contentBottomInset: CGFloat = 40
        static let tabContentSpacing: CGFloat = 24
        static let iconSpacing: CGFloat = 8
    }
}

#Preview {
    UserRadiosPage()
}

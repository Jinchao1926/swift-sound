//
//  UserRadiosPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import SwiftUI

struct UserRadiosPage: View {
    @ObservedObject var viewModel: UserDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.tabContentSpacing) {
            HStack(spacing: 0) {
                Text("Ta创建的播客")
                    .font(.font18.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                DisplayModePicker(selection: viewModel.radioDisplayMode) {
                    viewModel.updateRadioDisplayMode($0)
                }
            }

            UserRadioSection(
                state: viewModel.radioState,
                displayMode: viewModel.radioDisplayMode
            )
        }
        .padding(.top, Layout.contentTopInset)
        .padding(.bottom, Layout.contentBottomInset)
        .task {
            await viewModel.loadRadios()
        }
    }
}

private extension UserRadiosPage {
    enum Layout {
        static let contentTopInset: CGFloat = 10
        static let contentBottomInset: CGFloat = 40
        static let tabContentSpacing: CGFloat = 24
    }
}

#Preview {
    ScrollView {
        UserRadiosPage(viewModel: UserDetailViewModel(id: User.official.userId))
    }
    .frame(minWidth: 600, minHeight: 600)
    .padding()
}

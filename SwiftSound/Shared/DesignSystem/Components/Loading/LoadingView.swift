//
//  LoadingView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .controlSize(.small)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

#Preview {
    LoadingView()
}

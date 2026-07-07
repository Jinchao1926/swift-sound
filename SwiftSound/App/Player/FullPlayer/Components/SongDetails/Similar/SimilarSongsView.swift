//
//  SimilarSongsView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI

struct SimilarSongsView: View {
    let song: Song

    var body: some View {
        EmptyView()
    }
}

#Preview {
    SimilarSongsView(song: .preview)
        .padding()
        .background(Color(hex: 0x151515))
}

//
//  SongWikiView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI

struct SongWikiView: View {
    let song: Song

    var body: some View {
        EmptyView()
    }
}

#Preview {
    SongWikiView(song: .preview)
        .padding()
        .background(Color(hex: 0x151515))
}

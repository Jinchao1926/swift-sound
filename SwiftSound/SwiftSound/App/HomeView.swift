//
//  HomeView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct HomeView: View {
    @State private var selection: HomeRoute = .featured
    private let sidebarWidth: CGFloat = 203
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selection: $selection)
                .frame(width: sidebarWidth)
            
            DetailContainerView(route: selection)
                .frame(minWidth: 854, maxWidth: .infinity)
        }
        .frame(minHeight: 720)
    }
}

#Preview {
    HomeView()
}

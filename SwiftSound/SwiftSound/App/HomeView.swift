//
//  HomeView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView()
                .frame(width: 203)
            
            DetailContainerView()
                .frame(minWidth: 854, maxWidth: .infinity)
        }
        .frame(minHeight: 720)
        .environmentObject(router)
    }
}

#Preview {
    HomeView()
}

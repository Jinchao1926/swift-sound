//
//  HomeView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct HomeView: View {
    @State private var selection: HomeRoute = .featured
    
    var body: some View {
        HSplitView {
            SidebarView(selection: $selection)
                .frame(minWidth: 400, idealWidth: 400, maxWidth: 1300)
            
            DetailContainerView(route: selection)
                .frame(minWidth: 720)
        }
        .frame(minWidth: 1120, minHeight: 720)
    }
}

#Preview {
    HomeView()
}

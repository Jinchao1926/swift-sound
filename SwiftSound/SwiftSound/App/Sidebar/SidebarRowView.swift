//
//  SidebarRowView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct SidebarRowView: View {
    let route: HomeRoute

    var body: some View {
        Label(route.title, systemImage: route.systemImage)
    }
}

#Preview {
    SidebarRowView(route: .featured)
        .padding()
}

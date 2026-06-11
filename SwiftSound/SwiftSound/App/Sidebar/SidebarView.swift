//
//  SidebarView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: HomeRoute

    var body: some View {
        VStack(spacing: 0) {
//            TitleBarReserveView()

            List(selection: $selection) {
                ForEach(SidebarSection.allCases) { section in
                    Section(section.title) {
                        ForEach(section.routes) { route in
                            SidebarRowView(route: route)
                                .tag(route)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}

#Preview {
    SidebarView(selection: .constant(.featured))
}

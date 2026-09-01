//
//  MusicTableRouteLink.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

struct MusicTableRouteLink: View {
    let title: String
    let route: AppRoute

    @State private var isHovering = false

    var body: some View {
        Text(title)
            .font(.font13)
            .foregroundStyle(isHovering ? Color.textPrimary.opacity(0.8) : Color.textSecondary)
            .lineLimit(1)
            .onHover { isHovering = $0 }
            .routeLink(to: route)
    }
}

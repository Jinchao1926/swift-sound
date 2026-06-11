//
//  DetailContainerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct DetailContainerView: View {
    let route: HomeRoute
    
    var body: some View {
        switch route {
        case .featured:
            FeaturedPage()
        case .podcast:
            PodcastPage()
        case .follow:
            FollowPage()
        case .favorite:
            FavoritePage()
        case .played:
            PlayedPage()
        case .download:
            DownloadPage()
        }
    }
}

#Preview {
    DetailContainerView(route: .featured)
}

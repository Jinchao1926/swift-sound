//
//  AppRouter.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import Foundation
import Combine

final class AppRouter: ObservableObject {
    @Published private(set) var path: [AppRoute] = [.featured]

    var currentRoute: AppRoute {
        path.last ?? .featured
    }

    var canGoBack: Bool {
        path.count > 1
    }

    func navigate(to route: AppRoute) {
        guard route != currentRoute else { return }
        path.append(route)
    }

    func goBack() {
        guard canGoBack else { return }
        path.removeLast()
    }

    func navigateBack(to route: AppRoute) {
        guard
            route != currentRoute,
            let index = path.lastIndex(of: route)
        else {
            return
        }

        path.removeSubrange(path.index(after: index)...)
    }
}

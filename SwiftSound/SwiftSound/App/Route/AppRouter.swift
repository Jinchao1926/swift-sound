//
//  AppRouter.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import Foundation
import Combine

final class AppRouter: ObservableObject {
    @Published var rootRoute: AppRoute = .featured()
    @Published var path: [AppRoute] = []

    var currentRoute: AppRoute {
        path.last ?? rootRoute
    }

    var routeStack: [AppRoute] {
        [rootRoute] + path
    }

    var canGoBack: Bool {
        !path.isEmpty
    }

    func goBack() {
        guard canGoBack else { return }
        path.removeLast()
    }

    func navigateBack(to route: AppRoute) {
        guard route != currentRoute else { return }

        if route == rootRoute {
            path.removeAll()
            return
        }

        guard let index = path.lastIndex(of: route) else { return }
        path.removeSubrange(path.index(after: index)...)
    }

    func navigate(to route: AppRoute) {
        guard route != currentRoute else { return }
        path.append(route)
    }

    func navigate<Route: SecondaryRouteProtocol>(to route: Route) {
        navigate(to: route.destinationRoute)
    }
}

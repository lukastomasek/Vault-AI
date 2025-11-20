//
//  AppSharedPoint.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Foundation
import UIKit

enum AppRoutes {
    case main
    case `default`
}

final class AppSharedPoint {
    static let shared = AppSharedPoint()

    private var currentRoute: AppRoutes = .main

    private var currentViewController: UIViewController?

    func setRoute(_ route: AppRoutes) -> UIViewController? {
        currentRoute = route
        routeDidChange()

        return currentViewController
    }

    func getWindowWidth() -> CGFloat {
        UIScreen.main.bounds.width
    }

    private func routeDidChange() {
        switch currentRoute {
        case .main:
            let vm = MainChatViewModel() as MainChatViewModelProtocol
            let vc = MainChatViewController(viewModel: vm)
            currentViewController = vc
        case .default:
            let vc = UIViewController()
            currentViewController = vc
        }
    }
}

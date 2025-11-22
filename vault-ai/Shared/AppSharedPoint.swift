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

    // TODO: TEMP SOLUTION UNTIL ROUTER IS BUILD
    func setRoute(_ route: AppRoutes) -> UIViewController? {
        currentRoute = route
        routeDidChange()

        return currentViewController
    }

    func getWindowWidth() -> CGFloat {
        // Prefer a screen found via view/window context to avoid UIScreen.main (deprecated)
        if let screen = currentViewController?.view.window?.windowScene?.screen {
            return screen.bounds.width
        }
        // Fallback: try the view's trait environment to estimate width
        if let view = currentViewController?.view {
            return view.bounds.width
        }
        // As a last resort, use any connected scene's screen if available
        if let screen = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .compactMap({ $0.screen })
            .first
        {
            return screen.bounds.width
        }
        // If no context is available yet (e.g., before UI is on screen), return 0
        return 0
    }

    /// Prefer this when you have a concrete view context
    func getWindowWidth(from view: UIView) -> CGFloat {
        if let screen = view.window?.windowScene?.screen {
            return screen.bounds.width
        }
        return view.bounds.width
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

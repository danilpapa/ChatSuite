//
//  Utilities.swift
//  ChatClient
//
//  Created by setuper on 23.09.2025.
//

import UIKit

@MainActor
func topViewController(controller: UIViewController? = nil) -> UIViewController? {
    let controller = controller ?? UIApplication.shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }?.rootViewController
    
    if let nav = controller as? UINavigationController {
        return topViewController(controller: nav.visibleViewController)
    }
    if let tab = controller as? UITabBarController,
       let selected = tab.selectedViewController {
        return topViewController(controller: selected)
    }
    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }
    return controller
}

func `Main`(delay: Int = 0, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
        completion()
    }
}

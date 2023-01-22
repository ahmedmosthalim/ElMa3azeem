//
//  UIWindow+Extensions.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 06/11/2022.
//

import UIKit

extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(rootViewController)
    }

    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

//
//  UITabbar+NavigationControllerExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Foundation
import UIKit

extension UITabBarController {
    func hideTabbar() {
        UIView.animate(withDuration: 0.3) {
            self.tabBar.isHidden = true
            self.tabBar.layer.zPosition = -1
        }
    }

    func showTabbar() {
        UIView.animate(withDuration: 0.3) {
            self.tabBar.isHidden = false
            self.tabBar.layer.zPosition = 1
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        view.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
    }

    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    public func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    public func pushViewController(vc: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(vc, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}

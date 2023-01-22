//
//  CustomTabBarController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
 
    private var tabbarTitles = [String]()
    private let userTabbar = ["Home","My Orders","Offers","More"]
    private let ProviderTabbar = ["Home","My Orders","My products","More"]
    private let delegateTabbar = ["Home","My Orders","My account","More"]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupUI()
        
        tabbarTitles = setTabbarTitles()
        
        tabbarTitles.enumerated().forEach { [weak self] index, item in
            guard let self = self else { return }
            self.tabBar.items![index].title = item.localized
        }
    }

    private func setupUI() {
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize(width: 5.0, height: 0)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        tabBar.tintColor = UIColor.appColor(.MainColor)

        let tapBarAppearance = UITabBarAppearance()
        tapBarAppearance.backgroundColor = .appColor(.viewBackGround)
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: AppFont.Demi.rawValue, size: 12)!]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: AppFont.Demi.rawValue, size: 12)!]
        tapBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

        tabBar.standardAppearance = tapBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tapBarAppearance
        }
    }
    
    private func setTabbarTitles() -> [String] {
        guard let accountType = defult.shared.user()?.user?.accountType else { return userTabbar }
        switch accountType {
        case .user:
            return userTabbar
        case .delegate:
            return delegateTabbar
        case .provider:
            return ProviderTabbar
        case .unknown:
            return userTabbar
        }
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.allowAnimatedContent], completion: nil)
        }

        return true
    }
}

//
//  Extention+Material.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Foundation
import UIKit

func RestartToHome() {
    guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else{return}
    
    var sb = UIStoryboard()
    if let accountType = defult.shared.user()?.user?.accountType {
        switch accountType {
        case .user:
            sb = UIStoryboard(name: StoryBoard.Home.rawValue, bundle: nil)
            let mainTabBarController = sb.instantiateViewController(identifier: "CustomTabBarController")
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        case .delegate:
            sb = UIStoryboard(name: StoryBoard.DelegateHome.rawValue, bundle: nil)
            let mainTabBarController = sb.instantiateViewController(identifier: "CustomTabBarController")
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        case .provider:
            sb = UIStoryboard(name: StoryBoard.ProviderHome.rawValue, bundle: nil)
            let mainTabBarController = sb.instantiateViewController(identifier: "CustomTabBarController")
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        case .unknown:
            sb = UIStoryboard(name: StoryBoard.Home.rawValue, bundle: nil)
            let mainTabBarController = sb.instantiateViewController(identifier: "CustomTabBarController")
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }else {
       navigateToChooseLoginType()
    }
    }
func navigateToChooseLoginType() {
    let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
    let nav = CustomNavigationController(rootViewController: vc)
    MGHelper.changeWindowRoot(vc: nav)
}


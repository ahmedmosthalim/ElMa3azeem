//
//  SplashViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import UIKit

final class SplashViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in
            guard let self = self else { return }

            if defult.shared.getDataBool(forKey: .isFiristLuanch) == true || defult.shared.getDataBool(forKey: .isFiristLuanch) == nil {
                self.navigateToChooseLangusge()
            } else {
                if defult.shared.getData(forKey: .token) == "" || defult.shared.getData(forKey: .token) == nil {
                    self.navigateToChooseLoginType()
                } else {
//                    let vc = AppStoryboards.ProviderProduct.instantiate(ProviderAddProductGroupVC.self)
//                    let nav = CustomNavigationController(rootViewController: vc)
//                    MGHelper.changeWindowRoot(vc: nav)
                    RestartToHome()
                    
                }
            }
        }
    }

    func navigateToChooseLangusge() {
        let vc = AppStoryboards.Auth.instantiate(ChooseLanguageViewController.self)
        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }

    func navigateToLogin() {
        let vc = AppStoryboards.Auth.instantiate(LoginViewController.self)
        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }
    func navigateToChooseLoginType() {
        let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }
    
}

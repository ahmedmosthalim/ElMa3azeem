//
//  AboutUsRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit


protocol AboutUsRouter {
    func navigateToLogin()
}

class AboutUsRouterImplementation: AboutUsRouter {
    fileprivate weak var AboutUsViewController: AboutUsViewController?
    
    init(AboutUsViewController: AboutUsViewController) {
        self.AboutUsViewController = AboutUsViewController
    }
    
    func navigateToLogin() {
        let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue , bundle: nil)
//        let configurator = LoginConfiguratorImplementation()
        let vc  = storyboard.instantiateViewController(withIdentifier: "ChooseLoginType") as! ChooseLoginType
//        configurator.configure(LoginViewController: vc)
        AboutUsViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//
//  ChooseLanguageRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import UIKit


protocol ChangeLanguageRouter {
    func navigateToOnBoarding()
}

class ChangeLanguageRouterImplementation: ChangeLanguageRouter {
    fileprivate weak var ChangeLanguageViewController: ChangeLanguageViewController?

    init(ChangeLanguageViewController: ChangeLanguageViewController) {
        self.ChangeLanguageViewController = ChangeLanguageViewController
    }

    func navigateToOnBoarding() {
        let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue , bundle: nil)
//        let configurator = OnBoardingConfiguratorImplementation()
        let vc  = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
//        configurator.configure(OnBoardingViewController: vc)
        ChangeLanguageViewController?.navigationController?.pushViewController(vc, animated: true)
    }


}

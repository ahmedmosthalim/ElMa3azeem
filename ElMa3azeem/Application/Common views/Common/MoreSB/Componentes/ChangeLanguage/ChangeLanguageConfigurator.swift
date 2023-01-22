//
//  ChooseLanguageConfigurator.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import Foundation


protocol ChangeLanguageConfigurator {
    func configure(ChangeLanguageViewController:ChangeLanguageViewController)
}


class ChangeLanguageConfiguratorImplementation {

    func configure(ChangeLanguageViewController:ChangeLanguageViewController) {
        let view = ChangeLanguageViewController
        let router = ChangeLanguageRouterImplementation(ChangeLanguageViewController: view)
        
        let interactor = ChangeLanguageInteractor()
        let presenter = ChangeLanguagePresenterImplementation(view: view, router: router,interactor:interactor)
        
        
        ChangeLanguageViewController.presenter = presenter
    }
    
}

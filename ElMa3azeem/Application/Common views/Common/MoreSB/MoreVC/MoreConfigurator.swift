//
//  MoreConfigurator.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Foundation


protocol MoreConfigurator {
    func configure(MoreViewController:MoreViewController)
}


class MoreConfiguratorImplementation {

    func configure(MoreViewController:MoreViewController) {
        let view = MoreViewController
        let router = MoreRouterImplementation(MoreViewController: view)
        let interactor = MoreInteractor()
        let presenter = MorePresenterImplementation(view: view, router: router,interactor:interactor)
        
        MoreViewController.presenter = presenter
    }
    
}

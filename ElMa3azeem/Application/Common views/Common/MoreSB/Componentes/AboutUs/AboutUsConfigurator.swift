//
//  AboutUsConfigurator.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation


protocol AboutUsConfigurator {
    func configure(AboutUsController:AboutUsViewController)
}


class AboutUsConfiguratorImplementation {

    func configure(AboutUsViewController:AboutUsViewController) {
        let view = AboutUsViewController
        let router = AboutUsRouterImplementation(AboutUsViewController: view)

        let interactor = AboutUsInteractor()
        let presenter = AboutUsPresenterImplementation(view: view, router: router,interactor:interactor)


        AboutUsViewController.presenter = presenter
    }
    
}

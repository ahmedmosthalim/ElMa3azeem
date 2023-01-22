//
//  ProviderPackageVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/11/2022.
//

import UIKit

class ProviderPackageVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let vc = AppStoryboards.ProviderPackage.instantiate(SubscriptionPackagesVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  SyenchTimeInfoVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 07/11/2022.
//

import UIKit

class SyenchTimeInfoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
    }

    @IBAction func cancelAction(_ sender: Any) {
        removeAnimate()
    }
}

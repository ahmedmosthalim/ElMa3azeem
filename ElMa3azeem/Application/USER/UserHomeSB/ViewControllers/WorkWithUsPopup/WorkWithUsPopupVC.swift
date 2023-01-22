//
//  WorkWithUsPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import UIKit

class WorkWithUsPopupVC: UIViewController {
    @IBOutlet weak var popupView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
    }

    @IBAction func delegateAction(_ sender: Any) {
        SocialMedia.shared.openUrl(url: URLs.delegateJoinRequestUrl)
    }

    @IBAction func provideAction(_ sender: Any) {
        SocialMedia.shared.openUrl(url: URLs.providerJoinRequestUrl)
    }

    @IBAction func cancelAction(_ sender: Any) {
        removeAnimate()
        dismiss(animated: true)
    }
}

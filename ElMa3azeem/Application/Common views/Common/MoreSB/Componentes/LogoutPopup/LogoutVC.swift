//
//  LogoutVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import BottomPopup
import UIKit

class LogoutVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var isDissmess = false

    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }

    var logOut: (() -> Void)?
    @IBOutlet weak var backGroungView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
    }

    @IBAction func deleteAction(_ sender: Any) {
        isDissmess = true
        dismiss(animated: true)
        logOut?()
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension LogoutVC: BottomPopupDelegate {
    func bottomPopupDidDismiss() {
        if isDissmess == false {
            logOut?()
        }
    }
}


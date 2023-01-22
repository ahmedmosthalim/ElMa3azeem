//
//  PayFromWallerVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import UIKit
import BottomPopup

class PayFromWallerVC: BottomPopupViewController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var pticeLbl: UILabel!
    @IBOutlet weak var backGroungView: UIView!

    var walletPayment : (()->())?
    var price = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pticeLbl.text = "\("Are you sure about a pay".localized) \(price) \(defult.shared.getAppCurrency() ?? "") \("from wallet".localized) ?"
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
    }

    @IBAction func uesAction(_ sender: Any) {
        self.dismiss(animated: true)
        walletPayment?()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

//
//  AddCopounPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2111/2022.
//

import UIKit
import BottomPopup
import NVActivityIndicatorView

class AddCopounPopupVC: BottomPopupViewController {
    
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
    
    var addCopoun : ((_ coupon: String)->())?
    
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var backGroungView: UIView!
    @IBOutlet weak var copounTf: UITextField!
    
    var copoun = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
    }

    @IBAction func uesAction(_ sender: Any) {
        do {
            let code = try ValidationService.validate(coupon: copounTf.text)
            self.addCopoun?(code)
            self.dismiss(animated: true)
        } catch {
            self.showError(error: error.localizedDescription)
        }
    }
}

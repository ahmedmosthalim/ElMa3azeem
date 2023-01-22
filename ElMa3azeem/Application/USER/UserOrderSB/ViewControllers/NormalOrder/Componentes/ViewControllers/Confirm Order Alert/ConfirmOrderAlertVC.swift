//
//  ConfirmOrderAlertVC.swift
//  First Meal
//
//  Created by Ahmed Mostafa on 13/11/2022.
//

import Foundation
import UIKit
import BottomPopup

class ConfirmOrderAlertVC : BottomPopupViewController {
    
    var height                       : CGFloat?
    var topCornerRadius              : CGFloat?
    var presentDuration              : Double?
    var dismissDuration              : Double?
    var shouldDismissInteractivelty  : Bool?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var bottomStack      : UIStackView!
    @IBOutlet weak var backGroungView   : UIView!
    @IBOutlet weak var mainLbl          : UILabel!
    @IBOutlet weak var descriptionLbl   : UILabel!
    
    @IBOutlet weak var confirmButton    : UIButton!
    var backToCart   : (()->())?
    var confirmOrder : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomStack.semanticContentAttribute =  Language.isArabic() ? .forceLeftToRight :  .forceRightToLeft
//        continueBtn.setImage( Language.isArabic() ? UIImage(systemName: "arrow.right") : UIImage(systemName: "arrow.left"), for: .normal)
        
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        confirmOrder?()
    }
    
    @IBAction func backHomeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

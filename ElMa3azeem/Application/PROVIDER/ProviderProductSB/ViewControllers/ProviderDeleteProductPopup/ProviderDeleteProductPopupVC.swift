//
//  ProviderDeleteProductPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import BottomPopup
import UIKit

class ProviderDeleteProductPopupVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.4 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var backGroungView: UIView!
    
    var deleteProduct: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    @IBAction func DeleteAction(_ sender: Any) {
        dismiss(animated: true)
        deleteProduct?()
    }
}

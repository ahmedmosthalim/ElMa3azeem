//
//  SendOfferVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/01/2022.
//

import UIKit
import BottomPopup
import NVActivityIndicatorView

class SendOfferVC: BottomPopupViewController {
    
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
    
    @IBOutlet weak var deliveryPriceTf: UITextField!
    @IBOutlet weak var deliveryPriceView: UIView!
    
    var orderID = Int()
    var sendOfferSuccess : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        deliveryPriceView.appStypeTextField()
    }
    
    @IBAction func backAction(_ sender: Any) {
        do {
           
            let deliveryPrice = try ValidationService.validate(productPrice: deliveryPriceTf.text)
            
            delegateMakeOrderDeliveryOffer(orderID: orderID, deliveryPrice: deliveryPrice)
            
        } catch  {
            showError(error: error.localizedDescription)
        }
    }
}

//MARK: - API Extension
extension SendOfferVC {
    func delegateMakeOrderDeliveryOffer(orderID : Int , deliveryPrice:String) {
        self.showLoader()
            DelegateNetworkRouter.delegateMakeOffer(orderID: String(orderID), deliveryPrice: deliveryPrice).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.delegateMakeOrderDeliveryOffer(orderID: orderID, deliveryPrice: deliveryPrice)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.dismiss(animated: true)
                    self.sendOfferSuccess?()
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

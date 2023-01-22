//
//  RateDelegateVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 05/01/2022.
//

import BottomPopup
import Cosmos
import NVActivityIndicatorView
import UIKit

class RateDelegateVC: BottomPopupViewController {
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
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeRate: CosmosView!
    @IBOutlet weak var messageTv: AppTextViewStyle!
    @IBOutlet weak var storeNameLbl: UILabel!

    var storename = String()
    var userID = Int()
    var rate = Double()
    var orderID = Int()
    var delegateIconUrl = String()
    var delegateName = String()
    var name = String()
    var userType: AccountType?
    var rateUserSucess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        storeImage.setImage(image: delegateIconUrl, loading: true)
        
        if userType == .user {
            storeNameLbl.text = "\("How was the experience with".localized) \(storename) ?"
        } else {
//            storeNameLbl.text = "How was the experience with delivery ?".localized
            storeNameLbl.text =  "\("How was the experience with".localized) \(delegateName) ?"
        }

        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        messageTv.placeHolder = "If there are comments, add here".localized
    }

    @IBAction func confirmCancelAction(_ sender: Any) {
        do {
            let rate = try ValidationService.validate(rate: storeRate.rating)
            rateStore(orderID: "\(orderID)", rate: "\(rate)", userID: "\(userID)", comment: messageTv?.text ?? "")
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    @IBAction func CancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - API

extension RateDelegateVC {
    func rateStore(orderID: String, rate: String, userID: String, comment: String) {
        showLoader()
        CreateOrderNetworkRouter.rateUser(orderID: orderID, rate: rate, secondUserId: userID, comment: comment).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.rateStore(orderID: orderID, rate: rate, userID: userID, comment: comment)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.dismiss(animated: true)
                    self.rateUserSucess?()
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

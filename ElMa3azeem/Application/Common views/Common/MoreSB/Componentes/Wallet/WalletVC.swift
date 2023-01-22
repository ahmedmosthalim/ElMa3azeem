//
//  WalletVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit
import TransitionButton

class WalletVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var rechargeButton: TransitionButton!
    @IBOutlet weak var appCurncy: UILabel!
    
    // MARK: - Properties

    // MARK: - LifeCycle Events

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.hideTabbar()
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getCurrentBalanceAPi()
        }
        
        appCurncy.text = "".addAppCurrency
    }

    // MARK: - Logic

    // MARK: - Networking

    func getCurrentBalanceAPi() {
        showLoader()
        MoreNetworkRouter.wallet.send(WalletModel.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCurrentBalanceAPi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.currentBalance.text = data.data.wallet
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
        
    }
    
//    func navigateTChangePaymentMethod() {
//        let vc = AppStoryboards.Payment.instantiate(ChoosePaymentPrandVC.self)
//        vc.paymentReason = .chargeWallet
//        vc.successPayment = { [weak self] in
//            guard let self = self else {return}
//            self.getCurrentBalanceAPi()
//        }
//        present(vc, animated: true, completion: nil)
//    }
    
//    func navigateToOnlinePaymentPopup() {
//        let vc = AppStoryboards.Payment.instantiate(ChoosePaymentPrandVC.self)
//        vc.paymentReason = .chargeWallet
//        present(vc, animated: true, completion: nil)
//    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func rechargeWalletAction(_ sender: UIButton) {
        self.payPressed()
    }
     func payPressed() {
        let alert = UIAlertController(title: "Recharge wallet".localized, message: "Enter the amount you want to charge".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.default, handler: nil))
        
        alert.addTextField { textField in
            textField.placeholder = "Amount".localized
            textField.keyboardType = .asciiCapableNumberPad
        }
        
        alert.addAction(UIAlertAction(title: "Recharge wallet".localized, style: UIAlertAction.Style.default, handler: { _ in
            guard let textFields = alert.textFields else { return }
            if let ammount = textFields[0].text {
                self.validate(text: ammount)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    private func validate(text: String) {
        do {
            try ValidationService.validate(amount: text)
            
            let vc = AppStoryboards.More.instantiate(PaymentWebViewVC.self)
            vc.amount = text
            vc.PaymentStatus = "charge"
            self.navigationController?.pushViewController(vc, animated: true)
            

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

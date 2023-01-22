//
//  PaymentWebViewVC.swift
//  ElMa3azeem
//
//  Created by Ahmed Mostafa on 04/01/2023.
//

import UIKit
import WebKit


protocol PayOrderProtocol {
    func onSuccess()
}
class PaymentWebViewVC: BaseViewController {

    @IBOutlet weak var webView      : WKWebView!
    @IBOutlet weak var viewTitle    : UILabel!

    var userId  = defult.shared.user()?.user?.id
    var planID  : String?
    var orderId : String?
    var amount  : String?
    var PaymentStatus : String?
    
    
    var payOrderUrl = ""
    var paySubscriptionUrl  = ""
    var chargeWalletUrl = ""
    
    enum paymentType {
        
        case payOrder
        case paySubscription
        case chargeWallet
        

        var fullURL: String {
            switch self {
            case .payOrder:
                return  URLs.BASE + "pay-invoice"
            case .paySubscription:
                return  URLs.BASE + "pay-invoice"
            case .chargeWallet :
                return URLs.BASE + "payment"
            }
        }

        var fullRegisterURL: String {
            switch self {
            case .payOrder:
                return URLs.BASE + "pay-invoice"
            case .paySubscription:
                return URLs.BASE + "pay-invoice"
            case .chargeWallet :
                return URLs.BASE + "payment"
            }
        }

        var viewTitle: String {
            switch self {
            case .payOrder:
                return "Pay Order".localized
            case .paySubscription:
                return "Pay Subscription".localized
            case .chargeWallet :
                return "Charge Wallet".localized
            }
        }

        var successState: String {
            return fullURL + "/success"
        }
    }
    
    var payOrderProtocol : PayOrderProtocol?
    var paymentTypeVar : paymentType = .payOrder
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.navigationDelegate = self
        viewTitle.text = paymentTypeVar.viewTitle
        
        payOrderUrl = URLs.BASE + "/pay-invoice?user_id=\(userId ?? 0)&id=\(orderId ?? "")&type=order"

        paySubscriptionUrl = URLs.BASE + "/pay-invoice?user_id=\(userId ?? 0)&id=\(planID ?? "")&type=plan"
        // "https://mazeemapp.com/pay-invoice?user_id=144&id=1&type=plan"
        chargeWalletUrl = "https://mazeemapp.com/payment?amount=\(amount ?? "")&user_id=\(userId ?? 0)"
        
        
        switch PaymentStatus
        {
        case "order" :
            paymentTypeVar = .payOrder
            viewTitle.text = paymentTypeVar.viewTitle
            webView.load(goToPayOrder(url: payOrderUrl))
            
        case "subscription" :
        
            paymentTypeVar = .paySubscription
            viewTitle.text = paymentTypeVar.viewTitle
            webView.load(goToPayOrder(url: paySubscriptionUrl))
            
        case "charge" :
            paymentTypeVar = .chargeWallet
            viewTitle.text = paymentTypeVar.viewTitle
            webView.load(goToPayOrder(url: chargeWalletUrl))
            
        case .none:
            self.navigationController?.popViewController(animated: true)
        case .some(_):
            self.navigationController?.popViewController(animated: true)
        }
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    private func goToPayOrder(url: String) -> URLRequest {
        let stringURL = url
        print(url)
        guard let url = URL(string: stringURL) else { return URLRequest(url: URL(string: "")!) }
        let request = URLRequest(url: url)
        return request
    }
    

}
extension PaymentWebViewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url?.absoluteString))")

        if webView.url?.absoluteString == paymentTypeVar.successState {
            navigationController?.popViewController(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                self.payOrderProtocol!.onSuccess()
            })
            return
        }
    }
}

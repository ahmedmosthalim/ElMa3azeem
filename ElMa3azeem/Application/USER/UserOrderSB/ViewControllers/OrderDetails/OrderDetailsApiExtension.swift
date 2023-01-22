//
//  OrderDetailsApiExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 3011/2022.
//

import UIKit

extension UserOrderDetailsVC {
    func getOrderDetails(orderID : Int) {
        self.showLoader()
        CreateOrderNetworkRouter.orderDetails(orderID: "\(orderID)").send(GeneralModel<UserOrderDetailsModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getOrderDetails(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    
                    guard let orderType = response.data?.order.orderType, let orderStatus = response.data?.order.orderStatus else {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    
                    self.orderData = response.data
                    self.handelOrder(type: orderType, status: orderStatus)
                    self.setupOrderData()
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
    func userAcceiptOffer(offerID : Int) {
        self.showLoader()
        CreateOrderNetworkRouter.userAcceptDeliveryOffer(deliveryOfferID: "\(offerID)").send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.userAcceiptOffer(offerID: offerID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.hideViews()
                    self.getOrderDetails(orderID: self.orderID)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    func userRejectOffer(offerID : Int , index : IndexPath) {
        self.showLoader()
        CreateOrderNetworkRouter.userRejectDeliveryOffer(deliveryOfferID: "\(offerID)").send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.userAcceiptOffer(offerID: offerID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.orderOfferView.reloadView(index: index)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    func payWithWallet(orderID:Int){
        self.showLoader()
        CreateOrderNetworkRouter.walletPayment(orderID: String(orderID)).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.payWithWallet(orderID:orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.hideViews()
                    self.getOrderDetails(orderID: self.orderID)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

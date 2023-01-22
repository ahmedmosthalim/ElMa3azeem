//
//  ProviderOrderDetailsApiExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 14/11/2022.
//

import UIKit

extension ProviderOrderDetailsVC {
    func getOrderDetails(orderID: Int) {
        showLoader()
        ProviderOrderRourder.orderDetails(orderID: orderID).send(GeneralModel<UserOrderDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getOrderDetails(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let orderType = response.data?.order.orderType, let orderStatus = response.data?.order.orderStatus else {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }

                    self.orderData = response.data
                    self.handelOrder(type: orderType, status: orderStatus)
                    self.setupOrderData()
                    
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func providerAcceiptOrder(orderID: Int) {
        showLoader()
        ProviderOrderRourder.providerAcceptOrder(orderID: orderID).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.providerAcceiptOrder(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.hideViews()
                    self.getOrderDetails(orderID: self.orderID)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func orderIsReady(orderID : Int) {
        self.showLoader()
        ProviderOrderRourder.orderIsReady(orderID: orderID).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.orderIsReady(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    self.hideViews()
                    self.getOrderDetails(orderID: self.orderID)
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
    
    func orderIsDeliver(orderID : Int) {
        self.showLoader()
        ProviderOrderRourder.deliverOrder(orderID: orderID).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.orderIsReady(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    self.hideViews()
                    self.getOrderDetails(orderID: self.orderID)
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func payWithWallet(orderID: Int) {
        showLoader()
        CreateOrderNetworkRouter.walletPayment(orderID: String(orderID)).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.payWithWallet(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.hideViews()
                    self.getOrderDetails(orderID: self.orderID)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

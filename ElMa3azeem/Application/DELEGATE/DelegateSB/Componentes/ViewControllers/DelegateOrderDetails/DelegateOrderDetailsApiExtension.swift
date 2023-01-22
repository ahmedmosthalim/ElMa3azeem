//
//  DelegateOrderDetailsApiExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import Foundation
import UIKit

extension DelegateOrderDetailsVC {
    func getOrderDetails(orderID : Int) {
        self.hideViews()
        self.showLoader()
        DelegateNetworkRouter.delegateSinglOrder(orderID: "\(orderID)").send(GeneralModel<DelegateOrderDetailsModel>.self) { [weak self] result in
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
                    
                    self.setupPaymentView()
                    self.setupOrderData()
                    self.setupPaymentView()
                    self.delegateCanWithDraw()
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
    func acceptOrder(orderID : Int) {
        self.showLoader()
        DelegateNetworkRouter.acceptOrder(orderID: String(orderID)).send(GeneralModel<UserModel>.self) { [weak self] result in
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
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.getOrderDetails(orderID: orderID)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    func updateOrderIntransitState(orderID : Int , state : String) {
        self.showLoader()
        DelegateNetworkRouter.delegateIntransitOrder(orderID: String(orderID), deliveryStatus: state).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateOrderIntransitState(orderID: orderID, state: state)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.getOrderDetails(orderID: orderID)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    func fiinishOrder(orderID:Int) {
        self.showLoader()
            DelegateNetworkRouter.delegateFinishOrder(orderID: String(orderID)).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.fiinishOrder(orderID: orderID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.getOrderDetails(orderID: orderID)
                    self.navigateToRateDelegatePopup()
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

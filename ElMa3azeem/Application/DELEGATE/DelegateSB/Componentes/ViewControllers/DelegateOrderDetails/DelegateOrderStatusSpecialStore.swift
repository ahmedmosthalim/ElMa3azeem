//
//  DelegateOrderStatusSpecialStore.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.

import UIKit

//MARK: - Special Store
extension DelegateOrderDetailsVC {
    
    /*
         case Pending
         case InProgrese
         case Prepared
         case InTransit
         case Finished
     */
    
    func OrderSpecialStore(with status: OrderStatus) {
        switch status {
        case .pending:
            handelPendingSpecialStoreViews()
        case .inProgrese:
            handelInProgreseSpecialStoreViews()
        case .inTransit:
            handelInTransitSpecialStoreViews()
        case .finished:
            handelFinishedSpecialStoreViews()
        case .prepared:
            handelInProgreseSpecialStoreViews()
        default:
            navigationController?.popViewController(animated: true)
        }
    }
    
    func handelPendingSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.acceptOrderView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
        }
    }
    func handelInProgreseSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.deliveryInTransit.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
        }
    }
    func handelInTransitSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.deliveredView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
        }
    }
    func handelFinishedSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.userDataView.isHidden = false
            self.navigateToRateDelegatePopup()
            self.OrderStatusView.setStepperFinishedState()
        }
    }
}

//MARK: - Parcel Delivery
extension DelegateOrderDetailsVC {
    
    /*
         case Pending
         case InProgrese
         case ReachReciveLocation
         case ReachDeliveryLocation
         case Finished
     */
    
    func OrderParcelParcelDeliveryDelivery(with status: OrderStatus) {
        switch status {
        case .pending:
            handelPendingParcelDeliveryViews()
        case .inProgrese:
            handelInProgreseParcelDeliveryViews()
        case .reachedReciveLocation:
            handelReachReciveLocationParcelDeliveryViews()
        case .reachedDeliveryLocation:
            handelReachDeliveryLocationParcelDeliveryViews()
        case .finished:
            handelFinishedParcelDeliveryViews()
        default:
            return
        }
    }
    
    func handelPendingParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.acceptOrderView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
        }
    }
    func handelInProgreseParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.reachReceivingLocationView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
        }
    }
    func handelReachReciveLocationParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.reachDeliveryLocationView.isHidden = false
//            self.canWithdrawView.isHidden = true
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
        }
    }
    func handelReachDeliveryLocationParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.deliveredView.isHidden = false
//            self.canWithdrawView.isHidden = true
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 3)
        }
    }
    func handelFinishedParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.userDataView.isHidden = false
//            self.canWithdrawView.isHidden = true
            self.navigateToRateDelegatePopup()
            self.OrderStatusView.setStepperFinishedState()
        }
    }
}

//MARK: - Google Store + No Contruct
extension DelegateOrderDetailsVC {
    
    /*
         case Pending
         case inProgrese
         case recherStore
         case invoceCerated
         case Finished
     */
    
    func OrderGoogleStore(with status: OrderStatus) {
        switch status {
        case .pending:
            handelPendingGoogleStoreViews()
        case .inProgrese:
            handelInProgreseGoogleStoreViews()
        case .recherStore:
            handelRecherStoreGoogleStoreViews()
        case .invoiceCreated:
            handelInvoiceCeratedGoogleStoreViews()
        case .finished:
            handelFinishedGoogleStoreViews()
        default:
            return
        }
    }
    
    func handelPendingGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.acceptOrderView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
        }
    }
    func handelInProgreseGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.reachStoreLocationView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
        }
    }
    func handelRecherStoreGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.cerateInvoiceView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
        }
    }
    func handelInvoiceCeratedGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.deliveredView.isHidden = false
            self.isHaveInvoce()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 3)
        }
    }
    func handelFinishedGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.userDataView.isHidden = false
            self.isHaveInvoce()
            self.navigateToRateDelegatePopup()
            self.OrderStatusView.setStepperFinishedState()
        }
    }
}

//MARK: - Special Delivery
extension DelegateOrderDetailsVC {
    
    /*
     case Pending
     case InProgrese
     case InTransit
     case Finished
     */
    
    func OrderParcelSpecialPackageDelivery(with status: OrderStatus) {
        switch status {
        case .pending:
            handelPendingSpecialPackageViews()
        case .inProgrese:
            handelInProgreseSpecialPackageViews()
        case .inTransit:
            handelInTransitSpecialPackageViews()
        case .finished:
            handelFinishedSpecialPackageViews()
        default:
            return
        }
    }
    
    func handelPendingSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.orderDataView.isHidden = false
            self.readyToDeliverOrderView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
        }
    }
    func handelInProgreseSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.isHaveInvoce()
            self.isSpecialRequestWithInvoce()
        }
    }
    func handelInTransitSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.userDataView.isHidden = false
            self.deliveredView.isHidden = false
//            self.canWithdrawView.isHidden = true
            self.isHaveInvoce()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 3)
        }
    }
    func handelFinishedSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.userDataView.isHidden = false
//            self.canWithdrawView.isHidden = true
            self.navigateToRateDelegatePopup()
            self.isHaveInvoce()
            self.OrderStatusView.setStepperFinishedState()
        }
    }
}

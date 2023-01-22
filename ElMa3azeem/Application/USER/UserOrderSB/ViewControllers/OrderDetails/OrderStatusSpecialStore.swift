//
//  OrderStatusSpecialStore.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 3011/2022.
//

import UIKit

// MARK: - Special Store

extension UserOrderDetailsVC {
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
        case .prepared:
            handelPreparedSpecialStoreViews()
        case .inTransit:
            handelInTransitSpecialStoreViews()
        case .finished:
            handelFinishedSpecialStoreViews()
        case .canceld:
            handelCanceldSpecialStoreViews()
        default:
            navigationController?.popViewController(animated: true)
        }
    }

    func handelPendingSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.cancelOrderView.isHidden = false
            // self.priceView.isHidden = fals
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
        }
    }

    func handelInProgreseSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            // self.priceView.isHidden = false
            self.setupPaymentView()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelPreparedSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = self.orderData?.order.needsDelivery == true ? false : true
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.setupPaymentView()
            self.handleDelegateDataView(with: self.orderData?.order.orderStatus)
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
        }
    }

    func handelInTransitSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = self.orderData?.order.needsDelivery == true ? false : true
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.setupPaymentView()
            self.handleDelegateDataView(with: self.orderData?.order.orderStatus)
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 3)
        }
    }

    func handelFinishedSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            // self.priceView.isHidden = false
            self.handleDelegateDataView(with: self.orderData?.order.orderStatus)
            self.OrderStatusView.setStepperFinishedState()
            // self.progressCollectionView.reloadData()
        }
    }

    func handelCanceldSpecialStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.cancelReasonView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.OrderStatusView.setStepperCancelState()
        }
    }
}

// MARK: - Parcel Delivery

extension UserOrderDetailsVC {
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
        case .canceld:
            handelCanceldParcelDeliveryViews()
        default:
            return
        }
    }

    func handelPendingParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.cancelOrderView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
            // self.priceView.isHidden = false
            // self.progressCollectionView.reloadData()
        }
    }

    func handelInProgreseParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            // self.priceView.isHidden = false
            self.setupPaymentView()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelReachReciveLocationParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            // self.priceView.isHidden = false
            self.setupPaymentView()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
            ////self.progressCollectionView.reloadData()
        }
    }

    func handelReachDeliveryLocationParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            // self.priceView.isHidden = false
            self.setupPaymentView()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 3)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelFinishedParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.delegateDataView.isHidden = false
            // self.priceView.isHidden = false
            self.navigateToRateDelegatePopup()
            self.OrderStatusView.setStepperFinishedState()
            // self.progressCollectionView.reloadData()
        }
    }

    func handelCanceldParcelDeliveryViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.cancelReasonView.isHidden = false
            self.orderDataView.isHidden = false
            self.OrderStatusView.setStepperCancelState()
        }
    }
}

// MARK: - Special Delivery

extension UserOrderDetailsVC {
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
        case .canceld:
            handelCanceldParcelDeliveryViews()
        default:
            return
        }
    }

    func handelPendingSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.cancelOrderView.isHidden = false
            self.payNowBtn.isHidden = true
            self.currentStateIndex = 0
            // self.progressCollectionView.reloadData()
        }
    }

    func handelInProgreseSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            self.setupPaymentView()
            self.isHaveInvoce()
            self.isSpecialRequestWithInvoce()
            // self.progressCollectionView.reloadData()
        }
    }

    func handelInTransitSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            // self.priceView.isHidden = false
            self.setupPaymentView()
            self.isHaveInvoce()
            self.currentStateIndex = 3
            // self.progressCollectionView.reloadData()
        }
    }

    func handelFinishedSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.delegateDataView.isHidden = false
            // self.priceView.isHidden = false
            self.navigateToRateDelegatePopup()
            self.isHaveInvoce()
            self.currentStateIndex = -1
            // self.progressCollectionView.reloadData()
        }
    }

    func handelCanceledSpecialPackageViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.cancelReasonView.isHidden = false
            self.orderDataView.isHidden = false
            self.OrderStatusView.setStepperCancelState()
        }
    }
}

// MARK: - Google Store + No Contruct

extension UserOrderDetailsVC {
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
        case .canceld:
            handelCancelGoogleStoreViews()
        default:
            return
        }
    }

    func handelPendingGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.cancelOrderView.isHidden = false
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 0)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelInProgreseGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.setupPaymentView()
            self.payNowBtn.isHidden = true
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 1)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelRecherStoreGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.setupPaymentView()
            self.payNowBtn.isHidden = true
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 2)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelInvoiceCeratedGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.deliveryLocationBtn.isHidden = false
            self.storeDetailsView.isHidden = false
            self.complainteBtn.isHidden = false
            self.delegateDataView.isHidden = false
            self.setupPaymentView()
            self.OrderStatusView.setStepperCurrentIndex(toIndex: 3)
            // self.progressCollectionView.reloadData()
        }
    }

    func handelFinishedGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.OrderStatusView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.delegateDataView.isHidden = false
            self.navigateToRateStoreWithDelegatePopup()
            self.OrderStatusView.setStepperFinishedState()
            // self.progressCollectionView.reloadData()
        }
    }

    func handelCancelGoogleStoreViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.cancelReasonView.isHidden = false
            self.orderDataView.isHidden = false
            self.storeDetailsView.isHidden = false
            self.OrderStatusView.setStepperCancelState()
        }
    }
}

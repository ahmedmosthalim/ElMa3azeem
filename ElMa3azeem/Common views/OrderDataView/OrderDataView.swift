//
//  OrderDataView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 06/11/2022.
//

import UIKit

class OrderDataView: UIView {
    let XIB_NAME = "OrderDataView"

    // MARK: - outlets -

    @IBOutlet weak var priceView: UIStackView!

    /// base data
    @IBOutlet weak var reciveView: UIView!
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var paymentWayLbl: UILabel!
    @IBOutlet weak var receivingAddressLbl: UILabel!
    @IBOutlet weak var deliveryAddressLbl: UILabel!

    /// price data
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var deliveryPriceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var applicationCommissionLbl: UILabel!
    @IBOutlet weak var addedValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!

    @IBOutlet weak var deliveryAddressView: UIView!
    @IBOutlet weak var recevingAddressView: UIView!

    var deliveryAddressViewTapped: (() -> Void)?
    var recevingAddressViewTapped: (() -> Void)?

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupView()
    }

    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "XIB") is deinit, No memory leak found")
    }

    // MARK: - Design -

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }

    func setupView() {
        deliveryAddressView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.openMapToDeliveryLocation()
        }

        recevingAddressView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.openMapToRecivingLocation()
        }
    }

    @objc func openMapToRecivingLocation() {
        recevingAddressViewTapped?()
    }

    @objc func openMapToDeliveryLocation() {
        deliveryAddressViewTapped?()
    }

    func configView(orderData: OrderDetails?) {
        guard let orderType = orderData?.orderType else {
            return
        }
        switch orderType {
        case .specialStoreWithDelivery, .parcelDelivery, .specialPackage, .googleStore:
            priceView.isHidden = false
        case .defult:
            break
        }

        orderIDLbl.text = "# \(orderData?.id ?? 0)".validateInvoiceData()
        orderDateLbl.text = orderData?.createdAt
        deliveryTimeLbl.text = "\(orderData?.deliverTime?.validateInvoiceData() ?? "")"//" \("hour".localized)"
        paymentWayLbl.text = orderData?.paymentMethod?.name.validateInvoiceData()
        receivingAddressLbl.text = orderData?.receiveAddress?.validateInvoiceData()
        
        deliveryAddressLbl.text = orderData?.deliverAddress?.validateInvoiceData()
        deliveryAddressView.isHidden = !(orderData?.needsDelivery ?? false)
        deliveryPriceLbl.text = "\(orderData?.deliveryPrice?.validateInvoiceData() ?? "") \(defult.shared.getAppCurrency() ?? "")"
        discountLbl.text = "\(orderData?.discount?.validateInvoiceData() ?? "") \(defult.shared.getAppCurrency() ?? "")"
        applicationCommissionLbl.text = "\(orderData?.appPercentage?.validateInvoiceData() ?? "") \(defult.shared.getAppCurrency() ?? "")"
        addedValueLbl.text = "\(orderData?.addedValue?.validateInvoiceData() ?? "") \(defult.shared.getAppCurrency() ?? "")"
        totalLbl.text = "\(orderData?.totalPrice?.validateInvoiceData() ?? "") \(defult.shared.getAppCurrency() ?? "")"
        orderPriceLbl.text = orderData?.haveInvoice == true ? "\(orderData?.price?.validateInvoiceData() ?? "") \(defult.shared.getAppCurrency() ?? "")" : "No invoice issued yet".localized
    }
}

extension String {
    func validateInvoiceData() -> String {
        if self == "" || self == "0" || self == "0.00" {
            return " - "
        } else {
            return self
        }
    }
}

//
//  CompleteOrderVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1911/2022.
//

import BottomPopup
import UIKit

class CompleteOrderVC: BaseViewController {
    @IBOutlet weak var orderDetailsTableView        : IntrinsicTableView!
    @IBOutlet weak var paymentWayTableView          : IntrinsicTableView!

    @IBOutlet weak var locationTf                   : UITextField!
    
    @IBOutlet weak var locationView                 : AppTextFieldViewStyle!
    @IBOutlet weak var deliveryTimeView             : AppTextFieldViewStyle!
    
    @IBOutlet weak var deliveryTimeTf               : PickerTextField!
    @IBOutlet weak var deliveryDateTf               : PickerTextField!
    
    @IBOutlet weak var noteTv                       : AppTextViewStyle!
    
    @IBOutlet weak var messageView                  : UIView!
    @IBOutlet weak var couponView                   : UIView!


    @IBOutlet weak var deliveryStack                : UIStackView!
    @IBOutlet weak var deliveryImage                : UIImageView!

    @IBOutlet weak var fromStoreStack               : UIStackView!
    @IBOutlet weak var noteSteck                    : UIStackView!
    @IBOutlet weak var locationStack                : UIStackView!
    @IBOutlet weak var timesStackView               : UIStackView!


    @IBOutlet weak var fromStoreImage               : UIImageView!
    
    @IBOutlet weak var deliveryPriceStack           : UIStackView!
    
    
    @IBOutlet weak var deliveryTitleLbl             : UILabel!
    @IBOutlet weak var fromStoreTitleLbl            : UILabel!
    @IBOutlet weak var orderPriceLbl                : UILabel!
    @IBOutlet weak var deliveryPriceLbl             : UILabel!
    @IBOutlet weak var discountLbl                  : UILabel!
    @IBOutlet weak var appTaxLbl                    : UILabel!
    @IBOutlet weak var addedValueLbl                : UILabel!
    @IBOutlet weak var totalPriceLbl                : UILabel!

//    @IBOutlet weak var couponMessageView: UIView!
    @IBOutlet weak var couponMessageLbl             : UILabel!
    @IBOutlet weak var addCouponBtn                 : UIButton!

    @IBOutlet weak var deleteCartButton: SpaceingImageButton!
    var isCouponActive          = false
    var SelectedProduct         = [SelectedProductModel]()
    var storeID                 = Int()
    var needsDelivery           = true
    var paymentKey              = String()
    var deliveryLat             = String()
    var deliveryLong            = String()
    var deliveryAddres          = String()
    var coupon                  = String()
    var totalPrice              = Double()
    var selectedHoure           = Int()
    var storeType               = String()
    var store                   : Store?
    var paymentWayArray         = [PaymentMethod]()
    var selectedItem            = 0
    var backToStoreDetails      : ((_ products: [SelectedProductModel]) -> Void)?
    var haveDelivery            :Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getPaymentWay()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeStatusBarColor()
    }
    override func viewWillDisappear(_ animated: Bool) {
        backToStoreDetails?(SelectedProduct)
    }
    
    func setupView() {
        deleteCartButton.backgroundColor = UIColor.appColor(.StoreStateClose)
        if isCouponActive == true {
            couponMessageLbl.text = "You are now enjoying the discount".localized
            addCouponBtn.setTitle("Cancel".localized, for: .normal)
            addCouponBtn.backgroundColor = .appColor(.viewBackGround80)
        } else {
            coupon = ""
            couponMessageLbl.text = "Add a discount coupon".localized
            addCouponBtn.setTitle("active".localized, for: .normal)
            addCouponBtn.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.3647058824, blue: 0.2705882353, alpha: 0.3)
        }
        
        
        deliveryDateTf.pickerType        = .date
        deliveryDateTf.didSelected = { [weak self] in
                guard let self = self else { return }
            self.deliveryTimeTf.setupDateSatet(date: self.deliveryDateTf.selectedDate)
        }
        
        deliveryTimeTf.isOlderTimeAvilable = false
        deliveryTimeTf.pickerType          = .time
        deliveryTimeTf.didSelectWithError = { [weak self] message in
            guard let self = self else { return }
            self.showError(error: message)
        }

        noteTv.placeHolder               = "If there are comments, add here".localized

        paymentWayTableView.delegate     = self

        orderDetailsTableView.delegate   = self
        orderDetailsTableView.dataSource = self
        orderDetailsTableView.register(UINib(nibName: "SelectedProductCell", bundle: nil), forCellReuseIdentifier: "SelectedProductCell")
        orderDetailsTableView.reloadData()

        paymentWayTableView.dataSource = self
        paymentWayTableView.register(UINib(nibName: "PaymentWayCell", bundle: nil), forCellReuseIdentifier: "PaymentWayCell")

        if haveDelivery == true
        {
            selectDelivery()
            let deliveryTaped = UITapGestureRecognizer(target: self, action: #selector(selectDeliveryTap(_:)))
            deliveryStack.isUserInteractionEnabled = true
            deliveryStack.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
            deliveryStack.addGestureRecognizer(deliveryTaped)
            
            let fromStoreTaped = UITapGestureRecognizer(target: self, action: #selector(selectFromStoreTap(_:)))
            fromStoreStack.isUserInteractionEnabled = true
            fromStoreStack.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
            fromStoreStack.addGestureRecognizer(fromStoreTaped)
        }else
        {
            self.selectFromStore()
            let fromStoreTaped = UITapGestureRecognizer(target: self, action: #selector(selectFromStoreTap(_:)))
            fromStoreStack.isUserInteractionEnabled = true
            fromStoreStack.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
            fromStoreStack.addGestureRecognizer(fromStoreTaped)
            deliveryStack.isHidden = true
        }
        storeType = "special_stores"
//        selectDelivery()
        getOrderPrice()
        deliveryPriceLbl    .text           = "0.0".addAppCurrency
        discountLbl         .text           = "0.0".addAppCurrency
        addedValueLbl       .text           = "0.0".addAppCurrency
        appTaxLbl           .text           = "0.0".addAppCurrency

//        couponView.addDashedBorder()
    }

    func haveProduct() {
        if SelectedProduct.isEmpty {
            orderDetailsTableView.isHidden = true
        } else {
            orderDetailsTableView.isHidden = false
        }
    }

    func getOrderPrice() {
        var price = 0.0
        SelectedProduct.forEach { item in
            price += (item.productPrice * Double(item.quantity))
        }
        totalPrice = price
        orderPriceLbl.text = "\(price) \(defult.shared.getAppCurrency() ?? "")"

        if needsDelivery == false {
            totalPriceLbl.text = String(price).localized.addAppCurrency
        }
    }

    func selectDelivery() {
        deliveryImage       .image      = UIImage(named: "circle-mark-selected")
        deliveryTitleLbl    .textColor  = .appColor(.MainFontColor)

        fromStoreImage      .image      = UIImage(named: "circle-mark-not-selected")
        fromStoreTitleLbl   .textColor  = .appColor(.SecondFontColor)

        needsDelivery                   = true
        
        getOrderPrice()
        if deliveryLat != "" || deliveryLong != "" {
            getOrderPrices(storeID: store?.id ?? 0, receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, coupon: coupon, price: totalPrice)
        }

        UIView.animate(withDuration: 0.3) {
            self.locationStack  .isHidden = false
            self.timesStackView .isHidden = false
            self.noteSteck      .isHidden = false
            self.couponView     .isHidden = false
        }
    }

    func selectFromStore() {
        fromStoreImage      .image      = UIImage(named: "circle-mark-selected")
        fromStoreTitleLbl   .textColor  = .appColor(.MainFontColor)

        deliveryImage       .image      = UIImage(named: "circle-mark-not-selected")
        deliveryTitleLbl    .textColor  = .appColor(.SecondFontColor)

        deliveryPriceLbl    .text = "0.0".addAppCurrency
        discountLbl         .text = "0.0".addAppCurrency
        addedValueLbl       .text = "0.0".addAppCurrency
        appTaxLbl           .text = "0.0".addAppCurrency
        
        needsDelivery = false
        getOrderPrice()
        UIView.animate(withDuration: 0.3) {
            self.locationStack  .isHidden = true
            self.timesStackView .isHidden = true
            self.couponView     .isHidden = true
            self.noteSteck      .isHidden = false
        }
    }


    // MARK: - navigation

    func navigateToTrackOrdre() {
        let toolBar = UIToolbar()
        toolBar.barStyle        = UIBarStyle.default
        toolBar.isTranslucent   = true
        toolBar.sizeToFit()

        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreNotAvilablePopupVC") as! StoreNotAvilablePopupVC
        vc.backToHome = {
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    func navigationToChooseLocation() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SavedLocationVC") as! SavedLocationVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func showSuccessCreateOrder(orderID: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessAddOrderPopupVC") as! SuccessAddOrderPopupVC
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.backToHome()
        }

        vc.trackOrder = { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserOrderDetailsVC") as! UserOrderDetailsVC
            vc.orderID = orderID
            vc.isFromOrder = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        vc.popupDelegate = self

        present(vc, animated: true, completion: nil)
    }

    func navigateToAddCoupon() {
        do {
            _ = try ValidationService.validate(reciveLat: store?.lat, reciveLong: store?.long)
            _ = try ValidationService.validate(deliveryLat: deliveryLat, deliveryLong: deliveryLong)
            let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddCopounPopupVC") as! AddCopounPopupVC

            vc.addCopoun = { [weak self] text in
                guard let self = self else { return }
                self.getOrderPrices(storeID: self.store?.id ?? 0, receiveLat: self.store?.lat ?? "", receiveLong: self.store?.long ?? "", deliverLat: self.deliveryLat, deliverLong: self.deliveryLong, coupon: text, price: self.totalPrice)
            }
            present(vc, animated: true, completion: nil)
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    func backToHome() {
        navigationController?.popToViewController(ofClass: HomeViewController.self)
    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        backToStoreDetails?(SelectedProduct)
    }

    @objc func selectDeliveryTap(_ sender: UITapGestureRecognizer? = nil) {
        selectDelivery()
    }

    @objc func selectFromStoreTap(_ sender: UITapGestureRecognizer? = nil) {
        selectFromStore()
    }

    @IBAction func deleteAllProducts(_ sender: Any) {
        SelectedProduct.removeAll()
        getOrderPrice()
        if deliveryLat != "" || deliveryLong != "" {
            getOrderPrices(storeID: store?.id ?? 0, receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, coupon: coupon, price: totalPrice)
        }

        orderDetailsTableView.reloadData()
        haveProduct()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func chooseLocationAction(_ sender: Any) {
        loginAsVisitor(dismiss: true) { [weak self] in
            guard let self = self else { return }
            self.navigationToChooseLocation()
        }
    }

    @IBAction func addCouponAction(_ sender: Any) {
        if isCouponActive == true {
            coupon = ""
            isCouponActive = false
            getOrderPrices(storeID: store?.id ?? 0, receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, coupon: isCouponActive == true ? coupon : "", price: totalPrice)
        } else {
            navigateToAddCoupon()
        }
    }

    @IBAction func createOrderAction(_ sender: Any) {
        loginAsVisitor(dismiss: true) { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmOrderAlertVC") as! ConfirmOrderAlertVC
            vc.confirmOrder = {
                    self.loginAsVisitor(dismiss: true) { [weak self] in
                    guard let self = self else { return }
                    self.createOrder()
                    self.dismiss(animated: true)
                    }
                    }
            vc.backToCart = {
                self.dismiss(animated: true)
                }
            self.present(vc, animated: true, completion: nil)
        }
    }

    func createOrder() {
        do {
            _ = try ValidationService.validate(selectProduct: SelectedProduct)
            let payment = try ValidationService.validate(paymentWay: paymentKey)
            let array = createProductsGroup()

            if needsDelivery == true {
                let deliveryLocation = try ValidationService.validate(deliveryLat: deliveryLat, deliveryLong: deliveryLong)
                let _ = try ValidationService.validate(deliveryTime: deliveryTimeTf.text ?? "")
                let _ = try ValidationService.validate(deliveryDate: deliveryDateTf.text ?? "")

                createOrder(storeID: "\(storeID)", storeName: store?.name ?? "", storeIcon: store?.icon ?? "", groups: array.toString(), needsDelivery: needsDelivery, deliverTime: deliveryTimeTf.selectedDate.apiTime(), receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", receiveAddres: store?.address ?? "", deliverLat: deliveryLocation.lat, deliverLong: deliveryLocation.long, deliverAddres: locationTf.text ?? "", coupon: coupon, type: storeType, paymentType: payment, description: noteTv.text == "If there are comments, add here".localized ? "" : noteTv.text ?? "", deliveryDate: deliveryDateTf.selectedDate.apiDate())
            } else {
                createOrder(storeID: "\(storeID)", storeName: store?.name ?? "", storeIcon: store?.icon ?? "", groups: array.toString(), needsDelivery: needsDelivery, deliverTime: "", receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", receiveAddres: store?.address ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, deliverAddres: locationTf.text ?? "", coupon: coupon, type: storeType, paymentType: payment, description: noteTv.text == "If there are comments, add here".localized ? "" : noteTv.text ?? "", deliveryDate: "")
            }

        } catch {
            showError(error: error.localizedDescription)
        }
    }

    func createProductsGroup() -> [groups] {
        var array = [groups]()
        SelectedProduct.enumerated().forEach { index, product in
            array.append(groups(id: product.groupID, qty: product.quantity, additives: []))

            product.addition.forEach { addition in
                addition.productAdditives.enumerated().forEach { _, item in
                    if item.isSelected == true {
                        let index = array.firstIndex(where: { $0.id == product.productID }) ?? 0
                        array[index].additives?.append(singleGroups(id: item.id, qty: product.quantity))
                    }
                }
            }
        }
        return array
    }
}

// MARK: - Delegate Extension

extension CompleteOrderVC: SelectDelieryLocationProtocol {
    func selectLocation(address: Address) {
        if address.title == "" {
            locationTf.text = address.address
        } else {
            locationTf.text = address.title
        }
        deliveryAddres  = address.address
        deliveryLat     = address.lat
        deliveryLong    = address.long

        getOrderPrices(storeID: store?.id ?? 0, receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, coupon: isCouponActive == true ? coupon : "", price: totalPrice)
    }
}

extension CompleteOrderVC: BottomPopupDelegate {
    func bottomPopupViewLoaded() {
    }

    func bottomPopupWillAppear() {
    }

    func bottomPopupDidAppear() {
    }

    func bottomPopupWillDismiss() {
    }

    func bottomPopupDidDismiss() {
        backToHome()
    }

    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
    }
}

// MARK: - TableView Extension

extension CompleteOrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderDetailsTableView {
            return SelectedProduct.count
        } else {
            return paymentWayArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderDetailsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedProductCell", for: indexPath) as! SelectedProductCell
            cell.configCell(item: SelectedProduct[indexPath.row])

            cell.increaseProduct = { [weak self] in
                guard let self = self else { return }
                self.SelectedProduct[indexPath.row].totalPrice = self.SelectedProduct[indexPath.row].totalPrice + Double(self.SelectedProduct[indexPath.row].productPrice)
                self.SelectedProduct[indexPath.row].quantity = self.SelectedProduct[indexPath.row].quantity + 1
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self.getOrderPrice()

                if self.deliveryLat != "" || self.deliveryLong != "" {
                    self.getOrderPrices(storeID: self.store?.id ?? 0, receiveLat: self.store?.lat ?? "", receiveLong: self.store?.long ?? "", deliverLat: self.deliveryLat, deliverLong: self.deliveryLong, coupon: self.coupon, price: self.totalPrice)
                }
            }

            cell.decreaseProduct = { [weak self] in
                guard let self = self else { return }
                if self.SelectedProduct[indexPath.row].quantity > 1 {
                    self.SelectedProduct[indexPath.row].totalPrice = self.SelectedProduct[indexPath.row].totalPrice - Double(self.SelectedProduct[indexPath.row].productPrice)
                    self.SelectedProduct[indexPath.row].quantity = self.SelectedProduct[indexPath.row].quantity - 1
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.getOrderPrice()
                    if self.deliveryLat != "" || self.deliveryLong != "" {
                        self.getOrderPrices(storeID: self.store?.id ?? 0, receiveLat: self.store?.lat ?? "", receiveLong: self.store?.long ?? "", deliverLat: self.deliveryLat, deliverLong: self.deliveryLong, coupon: self.coupon, price: self.totalPrice)
                    }
                } else {
                    
                    let alertTitle = "Are You Want To Delete This Product ?".localized
                    let alertMessage = "This Product Only Will Be Removed From Your Cart".localized

                    let alert = UIAlertController(title: alertTitle , message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .systemBackground
                    alert.set(title: alertTitle, font: .systemFont(ofSize: 18), color: UIColor.appColor(.MainColor)!)
                    alert.set(message: alertMessage, font: .systemFont(ofSize: 10), color: UIColor.appColor(.SecondFontColor)!)
                    if self.SelectedProduct.count == 1
                    {
                        alert.message = "Now You Delete Your Only Product on Cart So You Will Be Directed To The Store Agian".localized
                    }
                    alert.addAction(UIAlertAction(title: "Confirm".localized, style: .destructive, handler: { (action: UIAlertAction!) in
                        
                        self.SelectedProduct[indexPath.row].totalPrice = self.SelectedProduct[indexPath.row].totalPrice - Double(self.SelectedProduct[indexPath.row].productPrice);
                        self.SelectedProduct[indexPath.row].quantity = self.SelectedProduct[indexPath.row].quantity - 1;
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                        self.getOrderPrice()
                        if self.deliveryLat != "" || self.deliveryLong != "" {
                            self.getOrderPrices(storeID: self.store?.id ?? 0, receiveLat: self.store?.lat ?? "", receiveLong: self.store?.long ?? "", deliverLat: self.deliveryLat, deliverLong: self.deliveryLong, coupon: self.coupon, price: self.totalPrice)
                        }
                        self.SelectedProduct.remove(at: indexPath.row)
                        self.orderDetailsTableView.reloadData()
                        self.haveProduct()
                        if self.SelectedProduct.isEmpty
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWayCell", for: indexPath) as! PaymentWayCell
            if indexPath.row < paymentWayArray.count {
                if indexPath.row == selectedItem {
                    cell.configCell(item: paymentWayArray[indexPath.row])
                    cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.40)
                    cell.cellBackGround.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
                    cell.cellBackGround.layer.borderWidth = 1
                    cell.selectImage.isHidden = false
                } else {
                    cell.configCell(item: paymentWayArray[indexPath.row])
                    cell.cellBackGround.backgroundColor = .appColor(.SecondViewBackGround)
                    cell.cellBackGround.layer.borderWidth = 0
                    cell.selectImage.isHidden = true
                }
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == paymentWayTableView {
            selectedItem    = indexPath.row
            paymentKey      = paymentWayArray[indexPath.row].key
            paymentWayTableView.reloadData()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - API Extension

extension CompleteOrderVC {
    func getPaymentWay() {
        showLoader()
        CreateOrderNetworkRouter.paymentMethod.send(GeneralModel<PaymentModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getPaymentWay()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.paymentWayArray.append(contentsOf: data.data?.paymentMethods ?? [])
                    self.paymentKey = self.paymentWayArray.first?.key ?? ""
                    self.paymentWayTableView.reloadData()
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func getOrderPrices(storeID: Int, receiveLat: String, receiveLong: String, deliverLat: String, deliverLong: String, coupon: String, price: Double) {
        showLoader()
        CreateOrderNetworkRouter.orderPrices(storeId: storeID, receiveLat: receiveLat, receiveLong: receiveLong, deliverLat: deliverLat, deliverLong: deliverLong, coupon: coupon, price: price).send(GeneralModel<OrderPriceModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.showNoInternetConnection {
                            self?.getOrderPrices(storeID: storeID, receiveLat: receiveLat, receiveLong: receiveLong, deliverLat: deliverLat, deliverLong: deliverLong, coupon: self?.isCouponActive == true ? coupon : "", price: price)
                        }
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.deliveryPriceLbl   .text = data.data?.deliveryPrice
                    self.discountLbl        .text = data.data?.discount
                    self.addedValueLbl      .text = data.data?.addedValue
                    self.appTaxLbl          .text = data.data?.appPercentage
                    self.totalPriceLbl      .text = data.data?.totalPrice

                    self.isCouponActive = data.data?.hasCoupon ?? false

                    if self.isCouponActive == true {
                        self.coupon = coupon
                        self.showSuccess(title: "", massage: "You are now enjoying the discount".localized)
                        self.couponView.backgroundColor = .appColor(.viewBackGround80)
                        self.couponMessageLbl.text = "You are now enjoying the discount".localized
                        self.addCouponBtn.setTitle("Cancel".localized, for: .normal)
                        self.addCouponBtn.backgroundColor = .appColor(.StoreStateClose)
                    } else {
                        self.coupon = ""
                        self.couponView.backgroundColor = .appColor(.MainColor)?.withAlphaComponent(0.30)
                        self.couponMessageLbl.text = "Add a discount coupon".localized
                        self.addCouponBtn.setTitle("active".localized, for: .normal)
                        self.addCouponBtn.backgroundColor = .appColor(.MainColor)
                    }

                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func createOrder(storeID: String, storeName: String, storeIcon: String, groups: String, needsDelivery: Bool, deliverTime: String, receiveLat: 
                     String, receiveLong: String, receiveAddres: String, deliverLat: String, deliverLong: String, deliverAddres: String, coupon: String, type: String, paymentType: String, description: String , deliveryDate:String) {
        showLoader()
        CreateOrderNetworkRouter.createOrder(storeID: storeID, storeName: storeName, storeIcon: storeIcon, groups: groups, needsDelivery: needsDelivery, deliverTime: deliverTime, receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentType, description: description , deliveryDate: deliveryDate).send(CreateOrderModel.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.createOrder(storeID: storeID, storeName: storeName, storeIcon: storeIcon, groups: groups, needsDelivery: needsDelivery, deliverTime: deliverTime, receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentType, description: description,deliveryDate: deliveryDate)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.showSuccessCreateOrder(orderID: data.data?.orderID ?? 0)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

// Group Model to create JSON of group
struct groups: Codable {
    let id: Int
    let qty: Int
    var additives: [singleGroups]?
}

struct singleGroups: Codable {
    var id: Int?
    var qty: Int?
}

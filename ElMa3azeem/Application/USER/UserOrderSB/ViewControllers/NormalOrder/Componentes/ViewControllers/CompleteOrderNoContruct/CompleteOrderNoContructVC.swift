//
//  CompleteOrderNoContructVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2211/2022.
//

import BottomPopup
import UIKit

class CompleteOrderNoContructVC: BaseViewController {
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var paymentWayTableView: IntrinsicTableView!

    @IBOutlet weak var lcoationView: UIView!
    @IBOutlet weak var locationTf: UITextField!
    @IBOutlet weak var deliveryTimeView: UIView!
    @IBOutlet weak var deliveryTimeTf: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var noteTv: UITextView!
    @IBOutlet weak var deliveryPriceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var appTaxLbl: UILabel!
    @IBOutlet weak var addedValueLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    @IBOutlet weak var couponMessageView: UIView!
    @IBOutlet weak var couponMessageLbl: UILabel!
    @IBOutlet weak var addCouponBtn: UIButton!
    var isCouponActive = false

    var viewTitle = String()
    var delivaryTimePicker = UIPickerView()
    var imageArray = [UIImage]()
    var imageArrayData = [Data]()

    var storeID = 0
    var paymentKey = String()
    var deliveryLat = String()
    var deliveryLong = String()
    var deliveryAddres = String()
    var coupon = String()
    var selectedHoure = 0
    var storeType = String()
    var store: Store?
    var deliveryTimeArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var paymentWayArray = [PaymentMethod]()
    var selectedPaymentIndrx = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getPaymentWay()
    }

    func setupView() {
        viewTitleLbl.text = viewTitle
        noteTv.delegate = self
        deliveryTimeTf.delegate = self
        paymentWayTableView.delegate = self
        deliveryTimeTf.inputView = delivaryTimePicker

        lcoationView.appStypeTextField()
        deliveryTimeView.appStypeTextField()
        messageView.appStypeTextField()

        paymentWayTableView.dataSource = self
        paymentWayTableView.register(UINib(nibName: "PaymentWayCell", bundle: nil), forCellReuseIdentifier: "PaymentWayCell")

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
        imageCollectionView.register(UINib(nibName: "UploadImageIconCell", bundle: nil), forCellWithReuseIdentifier: "UploadImageIconCell")

        if isCouponActive == true {
            couponMessageView.backgroundColor = .appColor(.MainColor)?.withAlphaComponent(0.20)
            couponMessageLbl.text = "You are now enjoying the discount".localized
            addCouponBtn.setTitle("Cancel".localized, for: .normal)
            addCouponBtn.backgroundColor = .appColor(.StoreStateClose)
        } else {
            coupon = ""
            couponMessageView.backgroundColor = #colorLiteral(red: 1, green: 0.7176470588, blue: 0.168627451, alpha: 0.15)
            couponMessageLbl.text = "Add a discount coupon".localized
            addCouponBtn.setTitle("active".localized, for: .normal)
            addCouponBtn.backgroundColor = #colorLiteral(red: 1, green: 0.7176470588, blue: 0.168627451, alpha: 1)
        }

        defultStyle()
        setupDeliveryTimePickerView()
    }

    func setupDeliveryTimePickerView() {
        delivaryTimePicker.delegate = self
        delivaryTimePicker.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Choose".localized, style: .done, target: self, action: #selector(doneDeliveryTimeTapped))

        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        deliveryTimeTf.inputView = delivaryTimePicker
        deliveryTimeTf.inputAccessoryView = toolBar
        deliveryTimeTf.tintColor = UIColor.clear
    }

    @objc func doneDeliveryTimeTapped() {
        deliveryTimeTf.text = "\(deliveryTimeArray[delivaryTimePicker.selectedRow(inComponent: 0)])" + " " + "hour".localized
        selectedHoure = deliveryTimeArray[delivaryTimePicker.selectedRow(inComponent: 0)]
        view.endEditing(true)
    }

    func defultStyle() {
        noteTv.text = "If there are comments, add here".localized
        noteTv.textColor = UIColor.lightGray
    }

    func createOrder() {
        do {
            let orderDetails = try ValidationService.validate(orderDetails: noteTv.text)
            let payment = try ValidationService.validate(paymentWay: paymentKey)
            let deliveryLocation = try ValidationService.validate(deliveryLat: deliveryLat, deliveryLong: deliveryLong)

            // MARK: - EDIT let delivaryTime = try ValidationService.validate(deliveryTime: selectedHoure)

            if storeID != 0 {
                storeType = "special_stores"
            } else {
                storeType = "google_places"
            }

            createOrder(storeID: String(store?.id ?? 0), storeName: store?.name ?? "", storeIcon: store?.icon ?? "", deliverTime: String(0), receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", receiveAddres: store?.address ?? "", deliverLat: deliveryLocation.lat, deliverLong: deliveryLocation.long, deliverAddres: deliveryAddres, coupon: coupon, type: "google_places", paymentType: payment, description: orderDetails, images: imageArrayData)

        } catch {
            showError(error: error.localizedDescription)
        }
    }

    func navigateToAddCoupon() {
        do {
            _ = try ValidationService.validate(reciveLat: store?.lat, reciveLong: store?.long)
            _ = try ValidationService.validate(deliveryLat: deliveryLat, deliveryLong: deliveryLong)
            let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddCopounPopupVC") as! AddCopounPopupVC

            vc.addCopoun = { [weak self] text in
                guard let self = self else { return }
                self.getOrderPrices(receiveLat: self.store?.lat ?? "", receiveLong: self.store?.long ?? "", deliverLat: self.deliveryLat, deliverLong: self.deliveryLong, coupon: text, price: 0.0)
            }
            present(vc, animated: true, completion: nil)
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    // MARK: - Actions

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

    func backToHome() {
        navigationController?.popToViewController(ofClass: HomeViewController.self)
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func chooseLocationAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SavedLocationVC") as! SavedLocationVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addCouponAction(_ sender: Any) {
        if isCouponActive == true {
            isCouponActive = false
            coupon = ""
            getOrderPrices(receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, coupon: isCouponActive == true ? coupon : "", price: 0.0)
        } else {
            navigateToAddCoupon()
        }
    }

    @IBAction func createOrderAction(_ sender: Any) {
        createOrder()
    }
}

// MARK: - Delegate Extension

extension CompleteOrderNoContructVC: SelectDelieryLocationProtocol {
    func selectLocation(address: Address) {
        if address.title == "" {
            locationTf.text = address.address
        } else {
            locationTf.text = address.title
        }
        deliveryAddres = address.address
        deliveryLat = address.lat
        deliveryLong = address.long

        getOrderPrices(receiveLat: store?.lat ?? "", receiveLong: store?.long ?? "", deliverLat: deliveryLat, deliverLong: deliveryLong, coupon: coupon, price: 0.0)
    }
}

extension CompleteOrderNoContructVC: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "If there are comments, add here".localized
            textView.textColor = UIColor.lightGray
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension CompleteOrderNoContructVC: BottomPopupDelegate {
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

extension CompleteOrderNoContructVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentWayArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWayCell", for: indexPath) as! PaymentWayCell
        if indexPath.row < paymentWayArray.count {
            if indexPath.row == selectedPaymentIndrx {
                cell.configCell(item: paymentWayArray[indexPath.row])
                cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.10)
                cell.selectImage.isHidden = false
            } else {
                cell.configCell(item: paymentWayArray[indexPath.row])
                cell.cellBackGround.backgroundColor = .white
                cell.selectImage.isHidden = true
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == paymentWayTableView {
            selectedPaymentIndrx = indexPath.row
            paymentKey = paymentWayArray[indexPath.row].key
            paymentWayTableView.reloadData()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - CollectionView Extension -

extension CompleteOrderNoContructVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageIconCell", for: indexPath) as! UploadImageIconCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell

            if indexPath.row - 1 < imageArray.count {
                cell.configerCell(image: imageArray[indexPath.row - 1], deletable: true)

                cell.deleteImage = { [weak self] in
                    guard let self = self else { return }
                    self.imageCollectionView.deleteItems(at: [indexPath])
                    self.imageArray.remove(at: indexPath.row - 1)
                    self.imageArrayData.remove(at: indexPath.row - 1)
                }
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}

// MARK: - PickerView Extension

extension CompleteOrderNoContructVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deliveryTimeArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(deliveryTimeArray[row])" + " " + "hour".localized
    }
}

// MARK: - ImagePickerViewController -

extension CompleteOrderNoContructVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.4)!
            imageArrayData.append(imageData)
            imageArray.append(image)
            picker.dismiss(animated: true, completion: nil)
            imageCollectionView.reloadData()
        }
    }
}

// MARK: - API Extension

extension CompleteOrderNoContructVC {
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

    func getOrderPrices(receiveLat: String, receiveLong: String, deliverLat: String, deliverLong: String, coupon: String, price: Double) {
        showLoader()
        CreateOrderNetworkRouter.orderPrices(storeId: storeID, receiveLat: receiveLat, receiveLong: receiveLong, deliverLat: deliverLat, deliverLong: deliverLong, coupon: coupon, price: price).send(GeneralModel<OrderPriceModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.showNoInternetConnection {
                            self?.getOrderPrices(receiveLat: receiveLat, receiveLong: receiveLong, deliverLat: deliverLat, deliverLong: deliverLong, coupon: self?.isCouponActive == true ? coupon : "", price: price)
                        }
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.deliveryPriceLbl.text = data.data?.deliveryPrice
                    self.discountLbl.text = data.data?.discount
                    self.addedValueLbl.text = data.data?.addedValue
                    self.appTaxLbl.text = data.data?.appPercentage
                    self.totalPriceLbl.text = data.data?.totalPrice

                    self.isCouponActive = data.data?.hasCoupon ?? false

                    if self.isCouponActive == true {
                        self.showSuccess(title: "", massage: "You are now enjoying the discount".localized)
                        self.couponMessageView.backgroundColor = .appColor(.MainColor)?.withAlphaComponent(0.20)
                        self.couponMessageLbl.text = "You are now enjoying the discount".localized
                        self.addCouponBtn.setTitle("Cancel".localized, for: .normal)
                        self.addCouponBtn.backgroundColor = .appColor(.StoreStateClose)
                    } else {
                        self.coupon = ""
                        self.couponMessageView.backgroundColor = #colorLiteral(red: 1, green: 0.7176470588, blue: 0.168627451, alpha: 0.15)
                        self.couponMessageLbl.text = "Add a discount coupon".localized
                        self.addCouponBtn.setTitle("active".localized, for: .normal)
                        self.addCouponBtn.backgroundColor = #colorLiteral(red: 1, green: 0.7176470588, blue: 0.168627451, alpha: 1)
                    }

                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func createOrder(storeID: String, storeName: String, storeIcon: String, deliverTime: String, receiveLat: String, receiveLong: String, receiveAddres: String, deliverLat: String, deliverLong: String, deliverAddres: String, coupon: String, type: String, paymentType: String, description: String, images: [Data]) {
        showLoader()

        var uploadedData = [UploadData]()
        for i in images {
            uploadedData.append(UploadData(data: i, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "images[]"))
        }

        CreateOrderNetworkRouter.createOrderNoContruct(storeID: "\(storeID)", storeName: storeName, storeIcon: storeIcon, deliverTime: "\(deliverTime)", receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliveryLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentKey, description: description).send(CreateOrderModel.self, data: uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.createOrder(storeID: storeID, storeName: storeName, storeIcon: storeIcon, deliverTime: deliverTime, receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentType, description: description, images: images)
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

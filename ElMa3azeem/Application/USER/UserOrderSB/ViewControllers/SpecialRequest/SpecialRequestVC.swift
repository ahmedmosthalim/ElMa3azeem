//
//  SpecialRequestVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2311/2022.
//

import BottomPopup
import UIKit

class SpecialRequestVC: BaseViewController {
    @IBOutlet weak var paymentWayTableView: IntrinsicTableView!

    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryTimeView: UIView!
    @IBOutlet weak var deliveryTf: UITextField!
    @IBOutlet weak var deliveryTimeTf: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var noteTv: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    var imageArray = [UIImage]()
    var imageArrayData = [Data]()

    var selectLocationFlag: SelectedLocation?
    var paymentKey = String()
    var deliveryLat = String()
    var deliveryLong = String()
    var deliveryAddres = String()
    var coupon = String()
    var storeType = "special_request"
    var deliveryTimeArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var paymentWayArray = [PaymentMethod]()
    var selectedPaymentIndex = 0
    var selectedHoure = 0
    var delivaryTimePicker = UIPickerView()

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.hideTabbar()
        // setupStatusBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getPaymentWay()
    }

    func setupView() {
        noteTv.delegate = self
        paymentWayTableView.delegate = self

        deliveryTimeView.appStypeTextField()
        deliveryView.appStypeTextField()
        messageView.appStypeTextField()

        paymentWayTableView.dataSource = self
        paymentWayTableView.register(UINib(nibName: "PaymentWayCell", bundle: nil), forCellReuseIdentifier: "PaymentWayCell")

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
        imageCollectionView.register(UINib(nibName: "UploadImageIconCell", bundle: nil), forCellWithReuseIdentifier: "UploadImageIconCell")
        

        defultStyle()
        setupDeliveryTimePickerView()
    }

    func defultStyle() {
        noteTv.text = "If there are comments, add here".localized
        noteTv.textColor = UIColor.lightGray
    }

    func setupDeliveryTimePickerView() {
        delivaryTimePicker.delegate = self
        delivaryTimePicker.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
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

    func createOrder() {
        do {
            let orderDetails = try ValidationService.validate(orderDetails: noteTv.text)
            let payment = try ValidationService.validate(paymentWay: paymentKey)
            let deliveryLocation = try ValidationService.validate(deliveryLat: deliveryLat, deliveryLong: deliveryLong)

            // MARK: - EDIT            let deliveeryTime = try ValidationService.validate(deliveryTime: selectedHoure)

            createOrder(deliverTime: "\(0)", deliverLat: deliveryLocation.lat, deliverLong: deliveryLocation.long, deliverAddres: deliveryAddres, type: storeType, paymentType: payment, description: orderDetails, images: imageArrayData)

        } catch {
            showError(error: error.localizedDescription)
        }
    }

    // MARK: - Navigation

    func navigateToChooseLocation() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SavedLocationVC") as! SavedLocationVC
        vc.delegate = self
        selectLocationFlag = .delivery
        navigationController?.pushViewController(vc, animated: true)
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

    @IBAction func deliveryLocationAction(_ sender: Any) {
        loginAsVisitor(dismiss: true) { [weak self] in
            guard let self = self else { return }
            self.navigateToChooseLocation()
        }
    }

    @IBAction func createOrderAction(_ sender: Any) {
        loginAsVisitor(dismiss: true) { [weak self] in
            guard let self = self else { return }
            self.createOrder()
        }
    }
}

// MARK: - Delegate Extension

extension SpecialRequestVC: SelectDelieryLocationProtocol {
    func selectLocation(address: Address) {
        if address.title == "" {
            deliveryTf.text = address.address
        } else {
            deliveryTf.text = address.title
        }
        deliveryAddres = address.address
        deliveryLat = address.lat
        deliveryLong = address.long
    }
}

extension SpecialRequestVC: UITextViewDelegate, UITextFieldDelegate {
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

extension SpecialRequestVC: BottomPopupDelegate {
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

extension SpecialRequestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentWayArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWayCell", for: indexPath) as! PaymentWayCell
        if indexPath.row < paymentWayArray.count {
            if indexPath.row == selectedPaymentIndex {
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
            selectedPaymentIndex = indexPath.row
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

extension SpecialRequestVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension SpecialRequestVC: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension SpecialRequestVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension SpecialRequestVC {
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

    func createOrder(deliverTime: String, deliverLat: String, deliverLong: String, deliverAddres: String, type: String, paymentType: String, description: String, images: [Data]?) {
        showLoader()

        var uploadedData = [UploadData]()
        if let newImages = images {
            newImages.forEach { image in
                uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "images[]"))
            }
        }

        CreateOrderNetworkRouter.createSpecialRequest(deliverTime: deliverTime, deliverLat: deliverLat, deliverLong: deliveryLong, deliverAddres: deliverAddres, type: type, paymentType: paymentKey, description: description).send(CreateOrderModel.self, data: uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.createOrder(deliverTime: deliverTime, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, type: type, paymentType: paymentType, description: description, images: images)
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

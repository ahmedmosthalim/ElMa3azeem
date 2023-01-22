//
//  CreateInvoiceVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/01/2022.
//

import UIKit

class CreateInvoiceVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var deliveryPrice: UITextField!
    @IBOutlet weak var invoceIMage: UIImageView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var deleteAction: UIButton!
    
    ///price data
    @IBOutlet weak var deliveryPriceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var applicationCommissionLbl: UILabel!
    @IBOutlet weak var addedValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var uploadImageBtn: UIButton!
    
    var createInvoiceSuccess : (()->())?
    var orderID = Int()
    var ImageData : Data?
    var isSelectImage = false
    var orderData : OrderPriceModel?
    
    var totalPrice = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadImageBtn.setImage(UIImage(named: Language.isArabic() ? "upload image icon" : "upload image icon"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryPrice.delegate = self
        priceView.appStypeTextField()
        deleteAction.isHidden = true
        setupOrderData()
    }
    
    func setupOrderData() {
        totalPrice = Double(orderData?.totalPrice ?? "") ?? 0
        deliveryPriceLbl.text = "\(orderData?.deliveryPrice ?? "") \(defult.shared.getAppCurrency() ?? "")"
        discountLbl.text = "\(orderData?.discount ?? "") \(defult.shared.getAppCurrency() ?? "")"
        applicationCommissionLbl.text = "\(orderData?.appPercentage ?? "") \(defult.shared.getAppCurrency() ?? "")"
        addedValueLbl.text = "\(orderData?.addedValue ?? "") \(defult.shared.getAppCurrency() ?? "")"
        totalLbl.text = "\(orderData?.totalPrice ?? "") \(defult.shared.getAppCurrency() ?? "")"
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addInvoceImageAction(_ sender: Any) {
        self.uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteAction.isHidden = true
        isSelectImage = false
        ImageData = nil
        invoceIMage.image = nil
    }
    
    @IBAction func createInvoiceAction(_ sender: Any) {
        do {
            let price = try ValidationService.validate(productPrice: deliveryPrice.text)
            if isSelectImage == true {
                createOrderInvoice(orderID: orderID, price: price)
            }else{
                showError(error: "Please select invoice image".localized)
            }
            
        } catch  {
            showError(error: error.localizedDescription)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let totla = (Double(textField.text ?? "") ?? 0) + totalPrice
        let totlaRounded = Double(round(1000 * totla) / 1000)
        print(totlaRounded)
        
        totalLbl.text =  String(totlaRounded)
        print(textField.text ?? "")
    }
    
}

//MARK: - ImagePickerViewController -
extension CreateInvoiceVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.4)!
            ImageData = imageData
            invoceIMage.image = image
            isSelectImage = true
            deleteAction.isHidden = false
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension CreateInvoiceVC {
    func createOrderInvoice(orderID: Int, price: String) {
        self.showLoader()
        
        var uploadedData = [UploadData]()
        uploadedData.append(UploadData(data: self.ImageData ?? Data(), fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png", name: "image"))
        
        DelegateNetworkRouter.delegateCreateOrderInvoce(orderID: String(orderID), price: price).send(GeneralModel<UserModel>.self ,data: uploadedData) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.createOrderInvoice(orderID: orderID, price: price)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.createInvoiceSuccess?()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

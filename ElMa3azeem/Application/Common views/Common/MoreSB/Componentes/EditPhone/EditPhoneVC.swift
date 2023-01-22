//
//  EditPhoneVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 05/11/2022.
//

import SwiftUI
import UIKit

class EditPhoneVC: BaseViewController {
    @IBOutlet weak var phoneTf: AppTextFieldStyle!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var phoneView: UIView!

    var userData: User?
    var contries = [Country]()
    var country: Country?
    var code = ""
    var imageData: Data?
    private var contryKeyPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        phoneView.semanticContentAttribute = .forceLeftToRight
        phoneTf.textAlignment = .left
    }

    func setupData() {
        code = country?.callingCode ?? ""
    }

    @IBAction func chooseCountryAction(_ sender: Any) {
        if contries.isEmpty == false {
            contryKeyPicker.dataSource = self
            contryKeyPicker.delegate = self

            let dummy = AppTextFieldStyle()
            view.addSubview(dummy)

            dummy.inputView = contryKeyPicker
            dummy.becomeFirstResponder()
        }
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func confirmAction(_ sender: Any) {
        guard let accountType = defult.shared.user()?.user?.accountType else { return }
        switch accountType {
        case .user:
            updateUserProfile(name: userData?.name ?? "", email: userData?.email ?? "", countryCode: userData?.countryKey ?? "", phoneNumber: phoneTf.text ?? "", image: imageData, gender: userData?.gender ?? "", cityId: userData?.cityId ?? 0, nationalityId: userData?.nationalityId ?? 0, address: userData?.address ?? "", lat: userData?.lat ?? "", long: userData?.long ?? "")

        case .delegate:
            updateDelegateProfile(name: userData?.name ?? "", countryCode: userData?.countryKey ?? "", phoneNumber: phoneTf.text ?? "", image: imageData, address: userData?.address ?? "", lat: userData?.lat ?? "", long: userData?.long ?? "", cityID: userData?.cityId ?? 0, regionID: userData?.regionId ?? 0)
            
        case .provider:
            updateProviderProfile(name: userData?.name ?? "", email: userData?.email ?? "", countryCode: userData?.countryKey ?? "", phoneNumber: phoneTf.text ?? "", image: imageData)
        case .unknown:
            break
        }
    }
}

// MARK: - PickerViewController -

extension EditPhoneVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = contries[row].callingCode
        return item
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = contries[row]
        codeLbl.text = item.callingCode
        country = item
        code = item.callingCode
        phoneTf.placeholder = item.example

        defult.shared.setData(data: item.currencyCode, forKey: .appCurrency)

        defult.shared.setData(data: item.currencyCodeAr, forKey: .appCurrencyAr)
        defult.shared.setData(data: item.currencyCodeEn, forKey: .appCurrencyEn)

        flagImage.setImage(image: item.flag, loading: false)
    }
}

extension EditPhoneVC {
    func updateUserProfile(name: String, email: String, countryCode: String, phoneNumber: String, image: Data?, gender: String, cityId: Int, nationalityId: Int, address: String, lat: String, long: String) {
        showLoader()
        var uploadedData = [UploadData]()
        if let image = image {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "edit_avatar"))
        }

        MoreNetworkRouter.userUpadteProfile(name: name, phoneNumber: phoneNumber, countryCode: countryCode, email: email, nationalityId: nationalityId, cityID: cityId, address: address, lat: lat, long: long, gender: gender).send(GeneralModel<UserModel>.self, data: uploadedData.isEmpty ? nil : uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateUserProfile(name: name, email: email, countryCode: countryCode, phoneNumber: phoneNumber, image: image, gender: gender, cityId: cityId, nationalityId: nationalityId, address: address, lat: lat, long: long)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    let vc = AppStoryboards.More.instantiate(EditPhoneNumberController.self)
                    vc.phoneNumber = data.data?.user?.changedPhone
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func updateProviderProfile(name: String?, email: String?, countryCode: String?, phoneNumber: String?, image: Data?) {
        showLoader()
        var uploadedData = [UploadData]()
        if let image = image {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "edit_avatar"))
        }

        MoreNetworkRouter.providerUpadteProfile(name: name, phoneNumber: phoneNumber, countryCode: countryCode, email: email).send(GeneralModel<UserModel>.self, data: uploadedData.isEmpty ? nil : uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateProviderProfile(name: name, email: email, countryCode: countryCode, phoneNumber: phoneNumber, image: image)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    let vc = AppStoryboards.More.instantiate(EditPhoneNumberController.self)
                    vc.phoneNumber = data.data?.user?.changedPhone
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func updateDelegateProfile(name: String, countryCode: String, phoneNumber: String, image: Data?, address: String, lat: String, long: String, cityID: Int, regionID: Int) {
        showLoader()
        var uploadedData = [UploadData]()
        if let image = image {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "edit_avatar"))
        }
        MoreNetworkRouter.delegateUpdateProfile(name: name, phoneNumber: phoneNumber, countryCode: countryCode, address: address, lat: lat, long: long, cityID: cityID, regionID: regionID).send(GeneralModel<UserModel>.self, data: uploadedData.isEmpty ? nil : uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateDelegateProfile(name: name, countryCode: countryCode, phoneNumber: phoneNumber, image: image, address: address, lat: lat, long: long, cityID: cityID, regionID: regionID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    let vc = AppStoryboards.More.instantiate(EditPhoneNumberController.self)
                    vc.phoneNumber = data.data?.user?.changedPhone
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

struct updatePhoneModel {
    var name: String?
    var email: String?
    var countryCode: String?
    var phoneNumber: String?
    var image: Data?
    var cityId: Int?
    var nationalityId: Int?
    var gender: String?

    init(name: String?, email: String?, countryCode: String?, phoneNumber: String?, image: Data?, cityId: Int?, nationalityId: Int?, gender: String?) {
        self.name = name
        self.email = email
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.image = image
        self.cityId = cityId
        self.nationalityId = nationalityId
        self.gender = gender
    }
}

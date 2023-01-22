//
//  EditProfleVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Alamofire
import CoreLocation
import TransitionButton
import UIKit

class EditProfleVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var viewTitle    : UILabel!
    @IBOutlet weak var email        : UIView!
    @IBOutlet weak var nameView     : UIView!
    @IBOutlet weak var userNameTf   : AppTextFieldStyle!
    @IBOutlet weak var phoneTf      : AppTextFieldStyle!
    @IBOutlet weak var phoneView    : UIView!
    @IBOutlet weak var mailTf       : AppTextFieldStyle!
    @IBOutlet weak var cityTf       : AppPickerTextFieldStyle!
    @IBOutlet weak var genderTf: AppPickerTextFieldStyle!
    @IBOutlet weak var nationalityTf: AppPickerTextFieldStyle!
    @IBOutlet weak var confirmBtn: TransitionButton!
    @IBOutlet weak var locationTf: AppTextFieldStyle!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var chooseCode: UIButton!

    @IBOutlet weak var changePhoneNumberLbl: UILabel!
    @IBOutlet weak var userProfileView: UIStackView!

    // MARK: - Properties

    var updateImage = false
    var imageData: Data?
    var contryKeyPicker = UIPickerView()
    var selectedNationality: Int?

    private var contries = [Country]()
    private var nationalities = [CitiesModel]()
    private var code = ""
    private var cities = [CitiesModel]()
    private var country: Country?
    private var cityId = 0
    private var nationalityId = 0
    private let accountType = defult.shared.user()?.user?.accountType
    private var location: CLLocationCoordinate2D?
    private var userGender: String = ""

    // login Social Variable
    var isSocialLogin = false
    var userName = String()
    var userMail = String()
    var userToken = String()

    private let genderType = [
        GeneralPicker(id: 0, title: "Male".localized, key: "male"),
        GeneralPicker(id: 1, title: "Female".localized, key: "female"),
    ]

    // MARK: - LifeCycle Events

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
        if isSocialLogin {
            viewTitle.text = "Complete Info".localized
        } else {
            viewTitle.text = "Edit my account".localized
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        changePhoneNumberLbl.addTapGesture { [weak self] in
            guard let self = self else { return }

            let vc = AppStoryboards.More.instantiate(EditPhoneVC.self)
            vc.contries = self.contries
            vc.country = self.country
            guard let user = defult.shared.user()?.user else { return }
            vc.userData = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
        switch accountType {
        case .delegate, .provider:
            userProfileView.isHidden = true
        case .user:
            userProfileView.isHidden = true
        case .unknown, .none:
            navigationController?.popViewController(animated: true)
        }
    }

    func setupView() {
        phoneView.semanticContentAttribute = .forceLeftToRight
        phoneTf.textAlignment = .left
        if isSocialLogin {
            userNameTf.text = userName == " " ? "" : userName
            userImage.image = UIImage(named: "avatar")
            mailTf.text = userMail
        } else {
            loginAsVisitor { [weak self] in
                guard let self = self else { return }
                self.getProfile()
            }
        }
        genderTf.setupData(data: genderType)

        nationalityTf.didSelected = { [weak self] in
            guard let self = self else { return }
            self.nationalityId = self.nationalityTf.selectedPickerData?.pickerId ?? 0
        }

        cityTf.didSelected = { [weak self] in
            guard let self = self else { return }
            self.cityId = self.cityTf.selectedPickerData?.pickerId ?? 0
        }

        genderTf.didSelected = { [weak self] in
            guard let self = self else { return }
            self.userGender = self.genderTf.selectedPickerData?.pickerKey ?? ""
        }
    }

    func setupEditProfileData(user: UserModel) {
        defult.shared.saveUser(user: user)

        userImage.setImage(image: defult.shared.user()?.user?.avatar ?? "")
        phoneTf.text = defult.shared.user()?.user?.phone
        userNameTf.text = defult.shared.user()?.user?.name
        locationTf.text = defult.shared.user()?.user?.address
        mailTf.text = defult.shared.user()?.user?.email

        let gender = genderType.first(where: { $0.key == user.user?.gender })
        genderTf.text = gender?.title
        genderTf.selectedPickerData = gender

        guard let lat = Double(defult.shared.user()?.user?.lat ?? "0.0"), let lon = Double(defult.shared.user()?.user?.long ?? "0.0") else {
            return
        }

        location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    // MARK: - Validation

    func validateOnData(userName: String?, phoneNumber: String?, email: String?, cityId: Int?, nationality: String?, gender: String?) throws {
        switch accountType {
        case .delegate, .provider:
            try ValidationService.validateName(userName)
            try ValidationService.validatePhone(phoneNumber)
            _ = try ValidationService.validateEmail(email)
        case .user:
            try ValidationService.validateName(userName)
            try ValidationService.validatePhone(phoneNumber)
            _ = try ValidationService.validateEmail(email)
            
//            _ = try ValidationService.validate(cityId: cityId)
//            try ValidationService.validate(nationality: nationality)
//            _ = try ValidationService.validate(address: locationTf.text, lat: location?.latitude, long: location?.longitude)
//            try ValidationService.validate(gender: gender)
            
        case .unknown, .none:
            break
        }
    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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

    @IBAction func chooseImageAction(_ sender: UIButton) {
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    @IBAction func chooseLocationAction(_ sender: Any) {
        let vc = AppStoryboards.Home.instantiate(LocationViewController.self)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func deleteAccountAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeleteAcountPopupVC") as! DeleteAcountPopupVC
        present(vc, animated: true, completion: nil)
    }

    @IBAction func confirmAction(_ sender: UIButton) {
        do {
            try validateOnData(userName: userNameTf.text, phoneNumber: phoneTf.text, email: mailTf.text, cityId: cityTf.selectedPickerData?.pickerId, nationality: nationalityTf.text, gender: genderTf.text)

            if isSocialLogin {
                updateUserProfileSocialLogin(name: userNameTf.text!, email: mailTf.text!, countryCode: codeLbl.text, phoneNumber: phoneTf.text!, image: imageData, token: userToken)
            } else {
                guard let accountType = defult.shared.user()?.user?.accountType else { return }
                switch accountType {
                case .user:
                    updateUserProfile(name: userNameTf.text ?? "", email: mailTf.text ?? "", countryCode: country?.callingCode ?? "", phoneNumber: phoneTf.text ?? "", image: imageData, gender: genderTf.selectedPickerData?.pickerKey ?? "", cityId: cityTf.selectedPickerData?.pickerId ?? 0, nationalityId: nationalityTf.selectedPickerData?.pickerId ?? 0, address: locationTf.text ?? "", lat: "\(location?.latitude ?? 0.0)", long: "\(location?.longitude ?? 0.0)")
                case .provider:
                    updateProviderProfile(name: userNameTf.text ?? "", email: mailTf.text ?? "", countryCode: country?.callingCode, phoneNumber: phoneTf.text ?? "", image: imageData)
                case .delegate, .unknown:
                    break
                }
            }

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

// MARK: - Picker Extention

extension EditProfleVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.4)!
            self.imageData = imageData
            userImage.image = image
            updateImage = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension EditProfleVC: didPickLocationDelegate {
    func finishPickingLocationWith(location: CLLocationCoordinate2D, address: String) {
        locationTf.text = address
        self.location = location
    }

    func failPickingLocation() {
    }
}

// MARK: - PickerViewController -

extension EditProfleVC: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension EditProfleVC {
    func getProfile() {
        showLoader()
        MoreNetworkRouter.showProfile.send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCountriseApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else { return }
                    self.setupEditProfileData(user: data)

                    self.getNationalities()
                    self.getCountriseApi()
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func getCountriseApi() {
        showLoader()
        AuthRouter.country.send(GeneralModel<CountrysModel>.self) { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCountriseApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else { return }

                    self.contries = data.countries

                    let index = data.countries.firstIndex(where: { $0.callingCode == defult.shared.user()?.user?.countryKey }) ?? 0
                    self.flagImage.setImage(image: self.contries[index].flag)
                    self.codeLbl.text = self.contries[index].callingCode
                    self.country = self.contries[index]

                    switch self.accountType {
                    case .user:
                        self.getCities(countryId: self.country?.id ?? 0)
                    case .provider, .delegate ,.unknown, .none:
                        break
                    }

                    if self.phoneTf.text == "" {
                        self.phoneTf.placeholder = self.contries[0].example

                        defult.shared.setData(data: self.contries[0].currencyCodeAr, forKey: .appCurrencyAr)
                        defult.shared.setData(data: self.contries[0].currencyCodeEn, forKey: .appCurrencyEn)
                        defult.shared.setData(data: self.contries[0].currencyCode, forKey: .appCurrency)
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func getCities(countryId: Int) {
        showLoader()
        MoreNetworkRouter.cities(id: countryId).send(GeneralModel<[CitiesModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCountriseApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else { return }
                    self.cities = data
                    self.cityTf.setupData(data: self.cities)
                    guard let city = self.cities.first(where: { $0.id == defult.shared.user()?.user?.cityId }) else {
                        self.cityTf.selectedPickerData = self.cities.first
                        return
                    }
                    self.cityTf.selectedPickerData = city
                    self.cityTf.text = city.name

                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func getNationalities() {
        showLoader()
        MoreNetworkRouter.nationalities.send(GeneralModel<[CitiesModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCountriseApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else { return }
                    self.nationalities = data
                    self.nationalityTf.setupData(data: self.nationalities)
                    let index = self.nationalities.firstIndex(where: { $0.id == defult.shared.user()?.user?.nationalityId }) ?? 0
                    self.nationalityTf.text = self.nationalities[index].name
                    self.nationalityTf.selectedPickerData = self.nationalities[index]
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    // MARK: - Update functions

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
                    self.navigationController?.popViewController(animated: true)
                    self.showSuccess(title: "", massage: "Updated Successfully".localized)
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
                    self.navigationController?.popViewController(animated: true)
                    self.showSuccess(title: "", massage: "Updated Successfully".localized)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func updateUserProfileSocialLogin(name: String?, email: String?, countryCode: String?, phoneNumber: String?, image: Data?, token: String) {
        showLoader()
        var uploadedData = [UploadData]()
        if let image = image {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "edit_avatar"))
        }
        MoreNetworkRouter.updateProfileSocialLogin(name: name, phoneNumber: phoneNumber, countryCode: countryCode, email: email, token: token).send(GeneralModel<UserModel>.self, data: uploadedData.isEmpty ? nil : uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateUserProfileSocialLogin(name: name, email: email, countryCode: countryCode, phoneNumber: phoneNumber, image: image, token: token)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController") as! ConfirmCodeViewController
                    vc.phone = data.data?.user?.changedPhone
                    vc.token = token
                    vc.isSocialLogin = true
                    self.navigationController?.pushViewController(vc, animated: true)

                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

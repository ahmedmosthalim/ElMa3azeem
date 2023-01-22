//
//  DelegateProfileVCViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Alamofire
import CoreLocation
import TransitionButton
import UIKit

class DelegateProfileVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var nameView             : UIView!
    
    @IBOutlet weak var userNameTf           : AppTextFieldStyle!
    @IBOutlet weak var phoneTf              : AppTextFieldStyle!
    @IBOutlet weak var fullNameTf           : AppTextFieldStyle!

    @IBOutlet weak var phoneView            : UIView!
    
    @IBOutlet weak var countryTF            : AppPickerTextFieldStyle!
    @IBOutlet weak var regionTf             : AppPickerTextFieldStyle!
    @IBOutlet weak var cityTf               : AppPickerTextFieldStyle!
    
    
    @IBOutlet weak var confirmBtn           : TransitionButton!
    @IBOutlet weak var locationTf           : AppTextFieldStyle!

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var carPlateInNumsTF: AppTextFieldStyle!
    @IBOutlet weak var carPlateInCharTF: AppTextFieldStyle!
    @IBOutlet weak var carModelYearTF: AppTextFieldStyle!
    @IBOutlet weak var carModelTF: AppPickerTextFieldStyle!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var codeLbl: UILabel!

    @IBOutlet weak var chooseCode: UIButton!
    @IBOutlet weak var changePhoneNumberLbl: UILabel!
    
    
    @IBOutlet weak var carRearImage         : UIImageView!
    @IBOutlet weak var carFrontImage        : UIImageView!
    @IBOutlet weak var driverLicenseImage   : UIImageView!
    
    @IBOutlet weak var carInfoBTN           : RoundedButton!
    @IBOutlet weak var personalInfoBTN      : RoundedButton!
    
    @IBOutlet weak var personalInfoStack    : UIStackView!
    @IBOutlet weak var carInfoStack         : UIStackView!
    
    // MARK: - Properties

    var isUserUpdateUserImage           = false
    var isUserUpdateCarFrontImage       = false
    var isUserUpdateCarRearImage        = false
    var isUserUpdateLicesneDriverImage  = false

    var userImageData       : Data?
    var carFrontData        : Data?
    var carRearData         : Data?
    var licenseDriverData   : Data?
    var selectedNationality : Int?
    private var imageType   : DelegateImageTypes = .userImage

    private var contries    = [Country]()
    private var regions     = [RegionModel]()
    private var cities      = [CitiesModel]()
    private var carTypesArray = [CarTypesModel]()
    private var code        = ""
    private var country     : Country?
    private var cityId      = 0
    private var location    : CLLocationCoordinate2D?

    // login Social Variable
    var isSocialLogin = false
    var userName = String()
    var userMail = String()
    var userToken = String()
    var callService: Bool = true

    // MARK: - LifeCycle Events

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.showTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if callService == true {
            if isSocialLogin {
                getCountriseApi()
                userNameTf.text = userName == " " ? "" : userName
                userImage.image = UIImage(named: "avatar")
            } else {
                loginAsVisitor { [weak self] in
                    guard let self = self else { return }
                    self.getCountriseApi()
                    self.getProfile()
                }
            }
        }
        callService = true
    }

    func setupView() {
        
        personalInfoBTN.selectButton()
        carInfoBTN.notSelectButton()
        carInfoStack.isHidden = true
        personalInfoStack.isHidden = false
//        phoneView.semanticContentAttribute = .forceLeftToRight
        phoneTf.textAlignment = .left
        regionTf.addTarget(self, action: #selector(chooseRegions(_:)), for: .allEvents)
        cityTf.addTarget(self, action: #selector(chooseCities(_:)), for: .allEvents)
        
        countryTF.didSelected = { [weak self] in
            guard let self = self else { return }
            self.regions.removeAll()
            self.regionTf.selectedPickerData = nil
            self.regionTf.text = nil
            self.getRegions(countryId: self.countryTF.selectedPickerData?.pickerId ?? 0)
        }
        
        regionTf.didSelected = { [weak self] in
            guard let self = self else { return }
            self.cities.removeAll()
            self.cityTf.selectedPickerData = nil
            self.cityTf.text = nil
            self.getCities(regionID: self.regionTf.selectedPickerData?.pickerId)
        }

        changePhoneNumberLbl.addTapGesture { [weak self] in
            guard let self = self else { return }

            let vc = AppStoryboards.More.instantiate(EditPhoneVC.self)
            vc.contries = self.contries
            vc.country = self.country
            guard let user = defult.shared.user()?.user else { return }
            vc.userData = user
            self.navigationController?.pushViewController(vc, animated: true)
        }

//        cityTf.didSelected = { [weak self] in
//            guard let self = self else { return }
//            self.cityId = self.cityTf.selectedPickerData?.pickerId ?? 0
//        }
    }
    
    @objc func chooseRegions(_ sender: UITextField) {
        do {
            _ = try ValidationService.validate(Regions: regions)
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    @objc func chooseCities(_ sender: UITextField) {
        do {
            _ = try ValidationService.validate(cities: cities)
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    func setupEditProfileData(user: UserModel) {
        defult.shared.saveUser(user: user)
        
        userImage.setImage(image: defult.shared.user()?.user?.avatar ?? "")
        carRearImage.setImage(image: defult.shared.user()?.user?.carFront ?? "")
        carFrontImage.setImage(image: defult.shared.user()?.user?.carBack ?? "")
        driverLicenseImage.setImage(image: defult.shared.user()?.user?.driverLicense ?? "")
        
        
        phoneTf.text = defult.shared.user()?.user?.phone
        userNameTf.text = defult.shared.user()?.user?.name
//        regionTf.text = defult.shared.user()?.user.
        cityTf.text = defult.shared.user()?.user?.city?.name
        locationTf.text = defult.shared.user()?.user?.address
        carModelTF.text = defult.shared.user()?.user?.carModel
        carModelYearTF.text = defult.shared.user()?.user?.manufacturingYear
        carPlateInCharTF.text = defult.shared.user()?.user?.carPlateInLetters
        carPlateInNumsTF.text = defult.shared.user()?.user?.carPlateInNum
        guard let lat = Double(defult.shared.user()?.user?.lat ?? "0.0"), let lon = Double(defult.shared.user()?.user?.long ?? "0.0") else {
            return
        }
        location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    // MARK: - Validation

    func validateOnData(userName: String?, phoneNumber: String?, cityId: Int?, region: String?) throws {
        try ValidationService.validateName(userName)
        try ValidationService.validatePhone(phoneNumber)
        try ValidationService.validate(region: region)
        _ = try ValidationService.validate(cityId: cityId)
        _ = try ValidationService.validate(address: locationTf.text, lat: location?.latitude, long: location?.longitude)
    }
    
    func validateCarData(carModel: String?, carYearModel: String?, carPlateInLetters: String?, carPlateInNumbers: String?)
    throws {
        _ = try ValidationService.carModel(carModel)
        _ = try ValidationService.carModelYear(carModelYear: carYearModel)
        _ = try ValidationService.carPlateInLetters(carPlateInLetters)
        _ = try ValidationService.carPlateInNumbers(carPlateInLetters: carPlateInNumbers)
        _ = try ValidationService.validate(licensePicture: driverLicenseImage.image?.pngData())
        _ = try ValidationService.validate(licensePicture: carFrontImage.image?.pngData())
        _ = try ValidationService.validate(licensePicture: carRearImage.image?.pngData())
        
    }

    // MARK: - Actions
    
    
    
    @IBAction func showPersonalInfoAction(_ sender: Any) {
        personalInfoBTN.selectButton()
        carInfoBTN.notSelectButton()
        carInfoStack.isHidden = true
        personalInfoStack.isHidden = false
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getCountriseApi()
            self.getProfile()
        }
    }
    @IBAction func showCarInfoAction(_ sender: Any) {
        personalInfoBTN.notSelectButton()
        carInfoBTN.selectButton()
        carInfoStack.isHidden = false
        personalInfoStack.isHidden = true
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getCountriseApi()
            self.getProfile()
            self.getCarType()
        }
    }
    
    @IBAction func newAction(_ sender: Any) {
        imageType = .licenseDriverImage
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }
    
    @IBAction func carFrontImageSelectionAction(_ sender: Any) {
        imageType = .carFrontImage
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }
    @IBAction func carRearImageSelectionAction(_ sender: Any) {
        imageType = .carRearImage
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }
    
    @IBAction func userImageSelectionAction(_ sender: Any) {
        imageType = .userImage
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }
    

    @IBAction func chooseLocationAction(_ sender: Any) {
        callService = false
        let vc = AppStoryboards.Home.instantiate(LocationViewController.self)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func deleteAccountAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeleteAcountPopupVC") as! DeleteAcountPopupVC
        present(vc, animated: true, completion: nil)
    }

    @IBAction func notificationWasPressed(_ sender: UIButton) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveCarInfoAction(_ sender: Any) {
        do {
            try validateCarData(carModel: carModelTF.text, carYearModel: carModelYearTF.text, carPlateInLetters: carPlateInCharTF.text, carPlateInNumbers: carPlateInNumsTF.text)
            updateDelegateCarInfo(carModel: carModelTF.text!, carModelYear: carModelYearTF.text!, carPlateInLetters: carPlateInCharTF.text!, carPlateInNumbers: carPlateInNumsTF.text!, LicenseDriverImage: driverLicenseImage.image?.pngData(), carFrontImage: carFrontImage.image?.pngData(), carRearImage: carRearImage.image?.pngData())
        }
        catch {
            showError(error: error.localizedDescription)
        }
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        do {
            try validateOnData(userName: userNameTf.text, phoneNumber: phoneTf.text, cityId: cityTf.selectedPickerData?.pickerId, region: regionTf.text)
            if isSocialLogin {
                updateUserProfileSocialLogin(name: userNameTf.text!, email: "", countryCode: codeLbl.text, phoneNumber: phoneTf.text!, image: userImageData, token: userToken)
            } else {
                updateDelegateProfile(name: userNameTf.text ?? "", countryCode: codeLbl.text ?? "", phoneNumber: phoneTf.text ?? "", image: userImageData, address: locationTf.text ?? "", lat: "\(location?.latitude ?? 0.0)", long: "\(location?.longitude ?? 0.0)", cityID: cityTf.selectedPickerData?.pickerId ?? 0, regionID: regionTf.selectedPickerData?.pickerId ?? 0)
            }

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

// MARK: - DelegateProfileVC Extention

extension DelegateProfileVC: didPickLocationDelegate {
    func finishPickingLocationWith(location: CLLocationCoordinate2D, address: String) {
        locationTf.text = address
        self.location = location
    }

    func failPickingLocation() {
    }
}

// MARK: - Picker Extention

extension DelegateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.4)!
            switch imageType
            {
            case .userImage :
                self.userImageData = imageData
                userImage.image = image
                isUserUpdateUserImage = true
            case .carFrontImage:
                self.carFrontData = imageData
                carFrontImage.image = image
                isUserUpdateCarFrontImage = true
            case .carRearImage:
                self.carRearData = imageData
                carRearImage.image = image
                isUserUpdateCarRearImage = true
            case .licenseDriverImage:
                self.licenseDriverData = imageData
                driverLicenseImage.image = image
                isUserUpdateLicesneDriverImage = true
            }
            picker.dismiss(animated: true, completion: nil)

        }
    }
}
enum DelegateImageTypes {
    case userImage
    case carFrontImage
    case carRearImage
    case licenseDriverImage
}

extension DelegateProfileVC {
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
                    self.countryTF.setupData(data: self.contries)

                    let index = data.countries.firstIndex(where: { $0.callingCode == defult.shared.user()?.user?.countryKey }) ?? 0

                    self.flagImage.setImage(image: self.contries[index].flag)
                    self.codeLbl.text = self.contries[index].callingCode
                    
                    
                    self.country = self.contries[index]
                    self.countryTF.text = self.country?.name
                    self.countryTF.selectedPickerData = self.contries[index]

                    self.getRegions(countryId: self.country?.id ?? 0)
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
    
    func getRegions(countryId: Int) {
        showLoader()
        MoreNetworkRouter.regions(id: countryId).send(GeneralModel<[RegionModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getRegions(countryId: countryId)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data, !data.isEmpty else {
                        self.showError(error: response.msg)
                        self.view.endEditing(true)
                        return
                    }
                    self.regions = data
                    self.regionTf.setupData(data: self.regions)
                    let index = self.regions.firstIndex(where: { $0.id == defult.shared.user()?.user?.city?.regionID }) ?? 0
                    self.regionTf.text = self.regions[index].name
                    self.regionTf.selectedPickerData = self.regions[index]
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
    

    func getCities(regionID: Int?) {
        showLoader()
        MoreNetworkRouter.cities(id: regionID ?? 0).send(GeneralModel<[CitiesModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCities(regionID:regionID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else { return }
                    self.cities = data
                    self.cityTf.setupData(data: self.cities)

                    let index = self.cities.firstIndex(where: { $0.id == defult.shared.user()?.user?.city?.id }) ?? 0
//                    self.cityTf.text = self.cities[index].name
//                    self.cityTf.selectedPickerData = self.cities[index]
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

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
                } else {
                    self.showError(error: response.msg)
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
                    if data.data?.user?.changedPhone != "" {
                        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EditPhoneNumberController") as! EditPhoneNumberController
                        vc.phoneNumber = data.data?.user?.changedPhone
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        self.showSuccess(title: "", massage: "Updated Successfully".localized)
                        self.myScrollView.setContentOffset(.zero, animated: true)
                        self.getProfile()
                    }

                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
    func updateDelegateCarInfo(carModel :String,carModelYear : String , carPlateInLetters:String,carPlateInNumbers:String,LicenseDriverImage: Data?,carFrontImage:Data?,carRearImage:Data?)
    {
        showLoader()
        var uploadedData = [UploadData]()
        if let image = LicenseDriverImage {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "driving_license"))
        }
        if let image = carFrontImage {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "car_front"))
        }
        if let image = carRearImage {
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "car_back"))
        }
        MoreNetworkRouter.delegateUpdateCarInfo(carModel: carModel, carModelYear: carModelYear, carPlateInNumbers: carPlateInNumbers, carPlateInLetters: carPlateInLetters).send(GeneralModel<UserModel>.self, data: uploadedData.isEmpty ? nil : uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateDelegateCarInfo(carModel: carModel, carModelYear: carModelYear, carPlateInLetters: carPlateInLetters, carPlateInNumbers: carPlateInNumbers, LicenseDriverImage: LicenseDriverImage, carFrontImage: carFrontImage, carRearImage: carRearImage)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.user?.changedPhone != "" {
                        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EditPhoneNumberController") as! EditPhoneNumberController
                        vc.phoneNumber = data.data?.user?.changedPhone
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        self.showSuccess(title: "", massage: "Updated Successfully".localized)
                        self.myScrollView.setContentOffset(.zero, animated: true)
                        self.getProfile()
                    }

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
    
    func getCarType() {
        showLoader()
        MoreNetworkRouter.getCarTypes.send(GeneralModel<[CarTypesModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCarType()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else { return }
                    self.carTypesArray = data
                    self.carModelTF.setupData(data: self.carTypesArray)

//                    let index = self.carTypesArray.firstIndex(where: { $0.id == defult.shared.user()?.user?.carModel }) ?? 0
//                    self.cityTf.text = self.cities[index].name
//                    self.cityTf.selectedPickerData = self.cities[index]
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

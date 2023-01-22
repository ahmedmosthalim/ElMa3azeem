//
//  ProviderAddNewBranchVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import CoreLocation
import UIKit
class ProviderAddNewBranchVC: BaseViewController {
    // MARK: - Outlets

    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var branchLocationTf: AppTextFieldStyle!
    @IBOutlet weak var branchLocationView: AppTextFieldViewStyle!
    @IBOutlet weak var phoneTf: AppTextFieldStyle!
    @IBOutlet weak var phoneView: AppTextFieldViewStyle!
    @IBOutlet weak var emailTf: AppTextFieldStyle!
    @IBOutlet weak var contryLbl: UILabel!
    @IBOutlet weak var contryImage: UIImageView!
  
    var branchID = Int()
    var screenReason: ScreenReason = .addNew
    private var location: CLLocationCoordinate2D?
    private var contryKeyPicker = UIPickerView()
    private var contries = [Country]()
    private var workTimes = [OpeningHour]()
    private var code = ""
    private var country: Country?
    private var branchData: StoreDetailsData?
    var activeSyenchTime = false
//    private var isShowPasswor = false {
//        didSet {
//            if isShowPasswor {
//                showPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
//                showPasswordBtn.tintColor = .gray
//            } else {
//                showPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
//                showPasswordBtn.tintColor = .gray.withAlphaComponent(0.50)
//            }
//        }
//    }
//
//    private var isShowConfirmPasswor = false {
//        didSet {
//            if isShowConfirmPasswor {
//                showConfirmPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
//                showConfirmPasswordBtn.tintColor = .gray
//            } else {
//                showConfirmPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
//                showConfirmPasswordBtn.tintColor = .gray.withAlphaComponent(0.50)
//            }
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeStatusBarColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        switch screenReason {
        case .addNew:
            viewTitleLbl.text = "Add new branch".localized
        case .edit:
            viewTitleLbl.text = "Edit branch".localized
            getBranchData(branchID: branchID)
        }
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        configGestures()
        configUI()
        getCountriseApi()
    }

    private func configUI() {
        phoneView.semanticContentAttribute = .forceLeftToRight
        phoneTf.textAlignment = .left
    }

    private func configGestures() {
        branchLocationView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.locationTapped()
        }
    }

    @objc func locationTapped() {
        navigateToChooseLoation()
    }

    private func setupBranchData(branch: StoreDetailsData?) {
        branchLocationTf.text = branch?.address
        location = CLLocationCoordinate2D(latitude: Double(branch?.lat ?? "") ?? 0, longitude: Double(branch?.long ?? "") ?? 0)
        contryLbl.text = branch?.countryCode
        code = branch?.countryCode ?? ""
        phoneTf.text = branch?.branchPhone
        emailTf.text = branch?.branchEmail
        workTimes = branch?.openingHours ?? []

        guard let currentCountry = contries.first(where: {$0.callingCode.contains(code)}) else {return}
        
//        guard let currentCountry = contries.first(where: { $0.callingCode == code}) else {return}
        country = currentCountry
        phoneTf.placeholder = currentCountry.example
        contryImage.setImage(image: currentCountry.flag, loading: false)
    }
    // MARK: - Events
    
    
    @IBAction func phoneTfEditingDidEnd(_ sender: Any) {
        if phoneTf.text?.isEmpty == false 
        {
            do {
            try ValidationService.validate(phone: phoneTf.text)
            }
            catch{
                self.showError(error: error.localizedDescription)
            }
        }else
        {
            showError(error: "Enter A Valid Phone Number ".localized)
        }
    }
    
    
    // MARK: - logic

    private func validate(address: String?, location: CLLocationCoordinate2D?, phone: String?, email: String?) throws {
        let address = try ValidationService.validate(address: address, lat: Double(location?.latitude ?? 0), long: Double(location?.longitude ?? 0))
        let phone = try ValidationService.validate(phone: phone)
        let email = try ValidationService.validateEmail(email)

        switch screenReason {
        case .addNew:
            branchData = StoreDetailsData(id: 0, categoryName: "", deliveryPrice: "", name: "", nameAr: "", nameEn: "", icon: "", cover: "", lat: String(describing: address.lat), long: String(describing: address.long), address: address.address, numRating: 0, rate: "", category: "", offerImage: "", offerAmount: "", offerType: "", offerMax: "", available: false, hasContract: false, isOpen: false, distance: "", offer: false, openingHours: workTimes, memu: [], ibanNumber: "", bankNumber: "", commercialImage: "", bankName: "", commercialId: "", branchPhone: phone, branchEmail: email, countryCode: country?.callingCode)
        case .edit:
            branchData?.lat = String(describing: address.lat)
            branchData?.long = String(describing: address.long)
            branchData?.address = address.address
            branchData?.branchPhone = phone
            branchData?.branchEmail = email
            branchData?.countryCode = country?.callingCode
            branchData?.openingHours = workTimes
        }
    }

    // MARK: - NAVIGATION

    private func navigateToChooseLoation() {
        let vc = AppStoryboards.Home.instantiate(LocationViewController.self)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToAddBranchTime(branchData: StoreDetailsData?) {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderAddNewBranchTimesVC.self)
        vc.branchData = branchData
        vc.activeSyenchTime = activeSyenchTime
        vc.screenReason = screenReason
        vc.branchBackup = { [weak self] data, activeSyenchTime in
            guard let self = self else { return }
            self.workTimes = data.openingHours
            self.activeSyenchTime = activeSyenchTime
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ACTION

    @IBAction func backAction(_ sender: Any) {
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

    @IBAction func confirmData(_ sender: Any) {
        do {
            try validate(address: branchLocationTf.text, location: location, phone: phoneTf.text, email: emailTf.text)

            navigateToAddBranchTime(branchData: branchData)

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

// MARK: - LocationDelegate

extension ProviderAddNewBranchVC: didPickLocationDelegate {
    func finishPickingLocationWith(location: CLLocationCoordinate2D, address: String) {
        branchLocationTf.text = address
        self.location = location
    }

    func failPickingLocation() {
    }
}

// MARK: - PickerViewController -

extension ProviderAddNewBranchVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
        contryLbl.text = item.callingCode
        country = item
        code = item.callingCode
        phoneTf.placeholder = item.example

        contryImage.setImage(image: item.flag, loading: false)
    }
}

// MARK: - API

extension ProviderAddNewBranchVC {
    func getCountriseApi() {
        showLoader()
        AuthRouter.country.send(GeneralModel<CountrysModel>.self) { [weak self] result in
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
                    self.contries = data.countries

                    if self.screenReason == .addNew {
                        if let country = data.countries.first {
                            self.country = country
                            self.code = country.callingCode
                            self.phoneTf.placeholder = country.example
                        }
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func getBranchData(branchID: Int) {
        showLoader()
        ProviderMoreRouter.getSingleBranch(branchId: branchID).send(GeneralModel<StoreDetailsData>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getBranchData(branchID: branchID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.branchData = response.data
                    self.setupBranchData(branch: response.data)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

//
//  ContuctUsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/11/2022.
//

import UIKit

class ContuctUsVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var userNameTf: AppTextFieldStyle!
    @IBOutlet weak var phoneTf: AppTextFieldStyle!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var messageTv: AppTextViewStyle!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var writeYourMessageLbl: UILabel!

    var contryKeyPicker = UIPickerView()
    private var contries = [Country]()

    // MARK: - Properties

    var contry: Country?
    var phone = String()

    // MARK: - LifeCycle Events

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.hideTabbar()
        getCountriseApi()
        setupView()
    }

    // MARK: - Logic

    func setupView() {
        messageTv.placeHolder = "Please enter complaint details".localized
        phoneView.semanticContentAttribute = .forceLeftToRight
        phoneTf.textAlignment = .left
        codeLbl.text = defult.shared.user()?.user?.countryKey ?? ""
        phoneTf.text = defult.shared.user()?.user?.phone ?? ""
    }

    // Validation
    func validation(name: String?, phoneNumber: String?, message: String?) throws {
        try ValidationService.validateName(name)
        try ValidationService.validatePhone(phoneNumber)
        let _ = try ValidationService.validate(complaintDetails: message)
    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func chooseCountryAction(_ sender: Any) {
        contryKeyPicker.dataSource = self
        contryKeyPicker.delegate = self

        let dummy = UITextField(frame: .zero)
        view.addSubview(dummy)

        dummy.inputView = contryKeyPicker
        dummy.becomeFirstResponder()
    }

    @IBAction func confirmAction(_ sender: UIButton) {
        do {
            try validation(name: userNameTf.text, phoneNumber: phoneTf.text, message: messageTv.text)
            contactUsAPi(name: userNameTf.text!, phone: phoneTf.text!, message: messageTv.text!)

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

// MARK: - PickerViewController -

extension ContuctUsVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
        flagImage.setImage(image: item.flag, loading: false)
    }
}

// MARK: - Api Extension

extension ContuctUsVC {
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
                    if self.phoneTf.text == "" {
                        self.phoneTf.placeholder = self.contries[0].example
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func contactUsAPi(name: String, phone: String, message: String) {
        showLoader()
        MoreNetworkRouter.contactUs(name: name, phone: phone, message: message).send(GeneralModel<ContactUsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.contactUsAPi(name: self?.userNameTf.text ?? "", phone: self?.phoneTf.text ?? "", message: self?.messageTv.text ?? "")
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

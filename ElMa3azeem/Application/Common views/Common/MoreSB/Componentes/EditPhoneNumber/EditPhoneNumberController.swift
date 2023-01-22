//
//  EditPhoneNumberController.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/4/22.
//

import UIKit
import OTPFieldView


class EditPhoneNumberController: BaseViewController {
    
    //MARK: - OutLets -
    @IBOutlet weak var resendCodeLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var confirmPhoneNumberBtn: UIButton!
    @IBOutlet weak var OtpCode: OTPFieldView!
    @IBOutlet weak var resendCodeBtn: UIButton!
    
    //MARK: - Properties -
    private var count = 60
    private var enterCode:String?
    var phoneNumber:String?
    
    //MARK: - LifeCycle Events -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupOtpView()
    }
    
    //MARK: - Logic -
    
    @objc func update() {
        if(count > 0) {
            resendCodeLbl.text = "You can resend the code in".localized
            codeLbl.text = "\(count) " + "second".localized
            count = count - 1
        }else{
            resendCodeLbl.text = "You haven't received the code yet ?".localized
            codeLbl.text = " Resend the code".localized
            resendCodeBtn.isEnabled = true
        }
    }
    
    func setupView() {
        resendCodeBtn.isEnabled = false
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    
    //MARK: - Networking -
    
    func updatePhoneNumerViaCode(code:String) {
        self.showLoader()
        MoreNetworkRouter.changePhone(code: code).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updatePhoneNumerViaCode(code: code)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: "Updated Successfully".localized)
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func resendCode() {
            self.showLoader()
        AuthRouter.resendCode(phone: phoneNumber!, token: defult.shared.getData(forKey: .token) ?? "").send(GeneralModel<UserModel>.self) { [weak self] result in
                guard let self = self else {return}
                self.hideLoader()
                switch result {
                case .failure(let error):
                    if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                        self.showNoInternetConnection { [weak self] in
                            self?.resendCode()
                        }
                    } else {
                        self.showError(error: error.localizedDescription)
                    }
                case .success(let data):
                    if data.key == ResponceStatus.success.rawValue {
                        self.resendCodeBtn.isEnabled = false
                        self.count = 60
                    }else{
                        self.showError(error: data.msg)
                    }
                }
            }
        }

    //MARK: - Actions -

    @IBAction func resendCodeAction(_ sender: Any) {
        resendCode()
    }
    @IBAction func updateAction(_ sender: UIButton) {
        do {
            let code = try ValidationService.validate(verificationCode: self.enterCode)
            updatePhoneNumerViaCode(code: code)
        }catch {
            self.showError(error: error.localizedDescription)
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - confirm code controller
extension EditPhoneNumberController : OTPFieldViewDelegate{
    func setupOtpView(){
        switch UIDevice().type {
        case .iPhoneSE,.iPhoneSE2,.iPhone6,.iPhone6S , .iPhone7, .iPhone8, .iPhone12Mini , .iPhoneXR, .iPhone13Mini :
            self.OtpCode.fieldSize = 43
        default:
            self.OtpCode.fieldSize = 50
        }
        
        self.OtpCode.filledBackgroundColor = .appColor(.viewBackGround)!
        self.OtpCode.defaultBackgroundColor = .appColor(.viewBackGround)!
        
        self.OtpCode.filledBorderColor = UIColor.appColor(.MainColor)!
        self.OtpCode.cursorColor = UIColor.appColor(.MainColor)!
        self.OtpCode.defaultBorderColor = #colorLiteral(red: 0.7656004429, green: 0.7601327896, blue: 0.7697883844, alpha: 1)
        
        self.OtpCode.fieldsCount = 6
        self.OtpCode.fieldBorderWidth = 1

        self.OtpCode.displayType = .roundedCorner
        self.OtpCode.otpInputType = .ascii
        self.OtpCode.separatorSpace = 8
        self.OtpCode.shouldAllowIntermediateEditing = false
        self.OtpCode.delegate = self
        self.OtpCode.resignFirstResponder()
        self.OtpCode.initializeUI()
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        self.enterCode = otp
        print(otp)
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        print(OtpCode.fieldSize)
        return true
    }
}

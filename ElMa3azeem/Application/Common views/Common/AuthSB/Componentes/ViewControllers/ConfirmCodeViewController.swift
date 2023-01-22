//
//  ConfirmCodeViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 21/11/2022.
//

import OTPFieldView
import SwiftUI
import TransitionButton
import UIKit

final class ConfirmCodeViewController: BaseViewController, OTPFieldViewDelegate {
    // MARK: - UIViewController Events

    @IBOutlet weak var resendCodeLbl    : UILabel!
    @IBOutlet weak var codeLbl          : UILabel!
    @IBOutlet weak var confirmBtn       : MainButton!
    @IBOutlet weak var OtpCode          : OTPFieldView!
    @IBOutlet weak var resendCodeBtn    : UIButton!
    @IBOutlet weak var resendCodeStack  : UIStackView!

    var count   = 60
    var token   : String?
    var phone   : String?
    var country : Country?
    var code    : String?
    var isSocialLogin: Bool = false

    //    for handle visitor
    var isVisitor   = false
    var visitorView : AnyClass?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if Language.isArabic() {
            resendCodeStack.semanticContentAttribute = .forceRightToLeft
        } else {
            resendCodeStack.semanticContentAttribute = .forceLeftToRight
        }
        setupOtpView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @objc func update() {
        if count > 0 {
            resendCodeLbl.text = "You can resend the code in".localized
            codeLbl.text = "\(count) " + "second".localized
            count = count - 1
        } else {
            resendCodeLbl.text = "You haven't received the code yet ?".localized
            codeLbl.text = " Resend the code".localized
            resendCodeBtn.isEnabled = true
        }
    }

    // MARK: - navigation

    private func handleNavigation() {
        guard let accountType = defult.shared.user()?.user?.accountType else { return }
        switch accountType {
        case .user:
            navigateToUserHome()
        case .delegate:
            navigateToDelegateHome()
        case .provider:
            navigateToProviderHome()
        case .unknown:
            showError(error: "Unknown user type")
        }
    }

    private func navigateToUserHome() {
        let vc = AppStoryboards.Home.instantiate(CustomTabBarController.self)
        MGHelper.changeWindowRoot(vc: vc)
    }

    private func navigateToDelegateHome() {
        let vc = AppStoryboards.DelegateHome.instantiate(CustomTabBarController.self)
        MGHelper.changeWindowRoot(vc: vc)
    }

    private func navigateToProviderHome() {
        let vc = AppStoryboards.ProviderHome.instantiate(CustomTabBarController.self)
        MGHelper.changeWindowRoot(vc: vc)
    }

    @IBAction func confirmCodeAction(_ sender: UIButton) {
        if code == nil
        {
            showError(error: "Please enter verfication code".localized)
            
        }else
        {
            do {
                let code = try ValidationService.validate(verificationCode: self.code)
                animationButton()
                if isSocialLogin == true {
                    updatePhoneNumerViaCodeSocialLogin(code: code, token: token ?? "")
                } else {
                    activeCode(code: code)
                }
            } catch {
                showError(error: error.localizedDescription)
            }
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func resendcodeAction(_ sender: UIButton) {
        resendCodeBtn.isEnabled = false
        count = 60
        resendCode()
    }
}

extension ConfirmCodeViewController {
    func activeSuccess(withAnimation: Bool) {
        if withAnimation == true {
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                DispatchQueue.main.async(execute: { [weak self] () -> Void in
                    guard let self = self else { return }
                        if self.isVisitor == true {
                            guard let _ = self.visitorView else { return }
                            self.navigationController?.popToViewController(ofClass: self.visitorView!.self, animated: true)
                            self.isVisitor = false
                        } else {
                            self.handleNavigation()
                        }
                        defult.shared.setData(data: true, forKey: .fromLogin)
                    })
                })
        } else {
            if  defult.shared.user()?.user?.accountType == .user {
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                    DispatchQueue.main.async(execute: { [weak self] () -> Void in
                        guard let self = self else { return }
                            let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
                            vc.phone = self.phone
                            vc.country = self.country
                            vc.token = self.token ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    })
            }
        }
    }

    func activeFail(message: String) {
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                guard let self = self else { return }
                    self.showError(error: message)
            })
        })
    }

    func animationButton() {
    }

    func setupView() {
        resendCodeBtn.isEnabled = false
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
}

// MARK: - confirm code controller

extension ConfirmCodeViewController {
    func setupOtpView() {
        switch UIDevice().type {
        case .iPhoneSE, .iPhoneSE2, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone12Mini, .iPhoneXR, .iPhone13Mini:
            OtpCode.fieldSize = 43
        default:
            OtpCode.fieldSize = 50
        }

        OtpCode.filledBackgroundColor   = .appColor(.viewBackGround)!
        OtpCode.defaultBackgroundColor  = .appColor(.viewBackGround)!

        OtpCode.filledBorderColor   = UIColor.appColor(.MainColor)!
        OtpCode.cursorColor         = UIColor.appColor(.MainColor)!
        OtpCode.defaultBorderColor  = #colorLiteral(red: 0.7656004429, green: 0.7601327896, blue: 0.7697883844, alpha: 1)

        OtpCode.fieldsCount         = 6
        OtpCode.fieldBorderWidth    = 1

        OtpCode.displayType         = .roundedCorner
        OtpCode.otpInputType        = .ascii
        OtpCode.separatorSpace      = 8
        OtpCode.shouldAllowIntermediateEditing = false
        OtpCode.delegate = self
        OtpCode.resignFirstResponder()
        OtpCode.initializeUI()
    }

    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otp: String) {
        code = otp
        print(otp)
    }

    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        print(OtpCode.fieldSize)
        return true
    }
}

extension ConfirmCodeViewController {
    func activeCode(code: String) {
        showLoader()
        AuthRouter.activeCode(code: code, token: token ?? "").send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.activeCode(code: code)
                    }
                } else {
                    self.activeFail(message: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.data?.user?.accountType == .user
                    {
                        if response.data?.user?.completedInfo ?? false {
                            self.activeSuccess(withAnimation: true)
                            defult.shared.setData(data: self.token ?? "", forKey: .token)
                            defult.shared.saveUser(user: response.data)
                            
                        } else {
                            self.activeSuccess(withAnimation: false)
                            defult.shared.setData(data: self.token ?? "", forKey: .token)
                            defult.shared.saveUser(user: response.data)
                            
                        }
                    }else
                    {
                        self.activeSuccess(withAnimation: true)
                        defult.shared.setData(data: self.token ?? "", forKey: .token)
                        defult.shared.saveUser(user: response.data)
                    }
                } else {
                    self.activeFail(message: response.msg)
                }
            }
        }
    }

    func resendCode() {
        showLoader()
        AuthRouter.resendCode(phone: phone ?? "", token: token ?? "").send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.resendCode()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.key == ResponceStatus.success.rawValue {
                        self.showSuccess(title: "", massage: response.msg)
                    } else {
                        self.showError(error: response.msg)
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func updatePhoneNumerViaCodeSocialLogin(code: String, token: String) {
        showLoader()
        MoreNetworkRouter.confirmPhoneSocialLogin(code: code, token: token).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updatePhoneNumerViaCodeSocialLogin(code: code, token: token)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    defult.shared.setData(data: self.token ?? "", forKey: .token)
                    self.activeSuccess(withAnimation: true)
                    defult.shared.saveUser(user: response.data)
                } else {
                    self.activeFail(message: response.msg)
                }
            }
        }
    }
}

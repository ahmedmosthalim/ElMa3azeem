//
//  LoginViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import LocalAuthentication
import AuthenticationServices
import UIKit
import GoogleSignIn
import FBSDKLoginKit
import MapKit

final class LoginViewController: BaseViewController{
    
    // MARK: - UIViewController Events
    @IBOutlet weak var socailStackView          : UIStackView!
    @IBOutlet weak var loginBtn                 : UIButton!
    @IBOutlet weak var phoneTf                  : UITextField!
    @IBOutlet weak var phoneVire                : UIView!
    @IBOutlet weak var contryImage              : UIImageView!
    @IBOutlet weak var contryLbl                : UILabel!
    @IBOutlet weak var facebookLoginBtn         : UIButton!
    @IBOutlet weak var skipLoginOrRegisterButton    : UIButton!
    //    @IBOutlet weak var registerBtn: UIButton!
    
    
    var contryKeyPicker     = UIPickerView()
    private var contries    = [Country]()
    private var code        = ""
    private var country     : Country?
    var accountTypeForLogin :String?
    
    //    for handle visitor
    var isVisitor           = false
    var visitorView         : AnyClass?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hideTabbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountriesApi()
        setupView()
        setUpSignInAppleButton()
    }
    
    func setupView() {
        phoneVire   .semanticContentAttribute   = .forceLeftToRight
        phoneTf     .textAlignment              = .left
//        registerBtn.titleLabel?.underLine(fontSide: 12)
        switch self.accountTypeForLogin
        {
        case "user" :
            skipLoginOrRegisterButton.setTitle("Login As A Visitor".localized, for: .normal)
            print("Login As A Visitor")
        case "provider":
            skipLoginOrRegisterButton.setTitle("Register As A Provider".localized, for: .normal)
            print("Register As A Provider")
        case "delegate":
            skipLoginOrRegisterButton.setTitle("Register As A Delegate".localized, for: .normal)
            print("Register As A Delegate")
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    //MARK: - Navigations
    func navigateToCompleteINfo(email : String , name : String , token : String) {
        let vc = UIStoryboard.init(name: StoryBoard.More.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditProfleVC") as! EditProfleVC
        vc.userMail = email
        vc.userName = name
        vc.isSocialLogin = true
        vc.userToken = token
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Action
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if code.isEmpty == false {
            do {
                let phone = try ValidationService.validate(phone: phoneTf.text!)
                login(phone: phone, code: code)
            } catch {
                self.showError(error: error.localizedDescription)
            }
        }else{
            self.showError(error: "please select country code".localized)
        }
        
    }
    
    @IBAction func skipAction(_ sender: Any) {
        switch self.accountTypeForLogin
        {
        case "user" :
            let vc = AppStoryboards.Home.instantiate(CustomTabBarController.self)
            MGHelper.changeWindowRoot(vc: vc)
        case "provider":
            let vc = AppStoryboards.Home.instantiate(RegisterViewController.self)
            vc.registerType = .provider
            self.navigationController?.pushViewController(vc, animated: true)
        case "delegate":
            let vc = AppStoryboards.Home.instantiate(RegisterViewController.self)
            vc.registerType = .delegate
            self.navigationController?.pushViewController(vc, animated: true)
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    @IBAction func loginWithGoogleAction(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: AppDelegate.signInConfig, presenting: self) { [weak self] (user, error) in
            guard error == nil else { return }
            guard let self = self else {return}
            
            guard let user = user else { return }
            let emailAddress = user.profile?.email ?? ""
            let fullName = user.profile?.name ?? ""
            
            self.loginSocial(socialID: user.userID ?? "", name: fullName , email: emailAddress)
        }
    }
    
    @IBAction func loginWithFaceBookAction(_ sender: Any) {
        LoginManager().logIn(permissions: ["public_profile", "email" , "user_photos"] , from: self) { [weak self] (result, error) in
            guard let self = self else {return}
            self.showUserInfoFromFacebook()
        }
    }
    
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping () -> Void) {
        guard canEvaluatePolicy() else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                
            }
        }
    }
    
}


//MARK: - PickerViewController -
extension LoginViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contries.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = contries[row].callingCode
        return item
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = contries[row]
        contryLbl.text = item.callingCode
        country = item
        code = item.callingCode
        phoneTf.placeholder = item.example
        defult.shared.setData(data: item.currencyCode, forKey: .appCurrency)
        
        defult.shared.setData(data: item.currencyCodeAr, forKey: .appCurrencyAr)
        defult.shared.setData(data: item.currencyCodeEn, forKey: .appCurrencyEn)
        
        contryImage.setImage(image: item.flag, loading: false)
    }
}



extension LoginViewController {
    func getCountriesApi() {
        self.showLoader()
        AuthRouter.country.send(GeneralModel<CountrysModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCountriesApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    guard let data = response.data else {return}
                    self.contries = data.countries
                    if let country = data.countries.first {
                        self.country = country
                        self.code = country.callingCode
                        self.phoneTf.placeholder = country.example
                        
                        defult.shared.setData(data: country.currencyCode, forKey: .appCurrency)
                        
                        defult.shared.setData(data: country.currencyCodeAr, forKey: .appCurrencyAr)
                        defult.shared.setData(data: country.currencyCodeEn, forKey: .appCurrencyEn)
                        
                    }
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
    
    func login(phone:String , code:String) {
        self.showLoader()
        switch self.accountTypeForLogin
        {
        case "user" :
            AuthRouter.login(phone: phone, country_key: code).send(GeneralModel<UserModel>.self) { [weak self] result in
                guard let self = self else {return}
                self.hideLoader()
                switch result {
                case .failure(let error):
                    if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                        self.showNoInternetConnection { [weak self] in
                            self?.login(phone: phone, code: code)
                        }
                    } else {
                        self.showError(error: error.localizedDescription)
                    }
                case .success(let response):
                    if response.key == ResponceStatus.success.rawValue {
                        let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue , bundle: nil)
                        let vc  = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController") as! ConfirmCodeViewController
                        vc.token            = response.data?.token
                        vc.isSocialLogin    = false
                        vc.phone            = phone
                        vc.country          = self.country
                        vc.isVisitor        = self.isVisitor
                        vc.visitorView      = self.visitorView
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.showError(error: response.msg)
                    }
                }
            }
        case "delegate" :
            AuthRouter.delegateLogin(phone: phone, country_key: code).send(GeneralModel<UserModel>.self) { [weak self] result in
                guard let self = self else {return}
                self.hideLoader()
                switch result {
                case .failure(let error):
                    if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                        self.showNoInternetConnection { [weak self] in
                            self?.login(phone: phone, code: code)
                        }
                    } else {
                        self.showError(error: error.localizedDescription)
                    }
                case .success(let response):
                    if response.key == ResponceStatus.success.rawValue {
                        let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue , bundle: nil)
                        let vc  = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController") as! ConfirmCodeViewController
                        vc.token            = response.data?.token
                        vc.isSocialLogin    = false
                        vc.phone            = phone
                        vc.country          = self.country
                        vc.isVisitor        = self.isVisitor
                        vc.visitorView      = self.visitorView
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.showError(error: response.msg)
                    }
                }
            }
            
        case "provider" :
            
                AuthRouter.storeLogin(phone: phone, country_key: code).send(GeneralModel<UserModel>.self) { [weak self] result in
                    guard let self = self else {return}
                    self.hideLoader()
                    switch result {
                    case .failure(let error):
                        if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                            self.showNoInternetConnection { [weak self] in
                                self?.login(phone: phone, code: code)
                            }
                        } else {
                            self.showError(error: error.localizedDescription)
                        }
                    case .success(let response):
                        if response.key == ResponceStatus.success.rawValue {
                            let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue , bundle: nil)
                            let vc  = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController") as! ConfirmCodeViewController
                            vc.token            = response.data?.token
                            vc.isSocialLogin    = false
                            vc.phone            = phone
                            vc.country          = self.country
                            vc.isVisitor        = self.isVisitor
                            vc.visitorView      = self.visitorView
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self.showError(error: response.msg)
                        }
                    }
                }
        case .none:
            hideLoader()
            return
        case .some(_):
            hideLoader()
            return
        }
    }
    
    func loginSocial(socialID: String, name: String, email: String) {
        self.showLoader()
        AuthRouter.socialLogin(socialID: socialID, name: name, email: email, token: "").send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.loginSocial(socialID: socialID, name: name, email: email)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "Register Successfully".localized, massage: "")
                    
                    if data.data?.user?.completedInfo == true {
                        
                        defult.shared.setData(data: data.data?.token ?? "", forKey: .token)
                        defult.shared.saveUser(user: data.data)
                        
                        RestartToHome()
                    }else{
                        self.navigateToCompleteINfo(email: email, name: name, token: data.data?.token ?? "")
                    }
                    
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

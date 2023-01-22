//
//  BaseViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import BottomPopup
import NVActivityIndicatorView
import SwiftMessages
import UIKit

enum BackGroundImage {
    case authBackGround
    case mainBackGround

    var image: UIImage {
        switch self {
        case .authBackGround:
//            return UIImage(named: "FoodBg")!
            return UIImage(named: "appBackGround")!
        case .mainBackGround:
            return UIImage(named: "appBackGround")!
        }
    }
}

enum VCs: String {
    case LoginViewController
    case ConfirmCodeViewController
    case CompleteProfileViewController
}

protocol BaseView: AnyObject {
    func showLoader()
    func hideLoader()
    func showError(error: String)
    func showSuccess(title: String, massage: String)
    func showNoInternetConnection(action: @escaping (() -> Void))
}

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    private var backgroundImage: UIImageView = UIImageView()

    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "BaseVC") is deinit, No memory leak found")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.navigationController?.isNavigationBarHidden = true
        setupBackground()
    }

    func setupBackground() {
        switch storyboardId {
        case VCs.LoginViewController.rawValue, VCs.ConfirmCodeViewController.rawValue, VCs.CompleteProfileViewController.rawValue:
            backgroundImage.image = BackGroundImage.authBackGround.image
            UIApplication.shared.statusBarStyle  = .darkContent
        default:
            backgroundImage.image = BackGroundImage.mainBackGround.image
            UIApplication.shared.statusBarStyle  = .darkContent

        }

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.layer.zPosition = -5
        view.addSubview(backgroundImage)

        view.sendSubviewToBack(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -40),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}

extension BaseViewController: BaseView {
    func showLoader() {
        startAnimating()
    }

    func hideLoader() {
        stopAnimating()
    }

    func showError(error: String) {
        showMessage(title: "Error".localized, sub: error, type: .error, layout: .messageView)
    }

    func showSuccess(title: String, massage: String) {
        showMessage(title: title, sub: massage, type: .success, layout: .messageView)
    }

    func showNoInternetConnection(action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "Connection error".localized, message: "There was a connection error, make sure you have an internet connection and try again".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again".localized, style: .default, handler: { _ in
            action()
        }))
        UIDevice.vibrate()
        present(alert, animated: true, completion: nil)
    }

    func loginAsVisitor(dismiss: Bool? = false, action: @escaping (() -> Void)) {
        if defult.shared.getData(forKey: .token) == "" || defult.shared.getData(forKey: .token) == nil {
            let alert = UIAlertController(title: "Warning".localized, message: "You must login to continue".localized, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Login".localized, style: .default, handler: { _ in
                let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ChooseLoginType") as! ChooseLoginType
//                vc.isVisitor = true
//                vc.visitorView = self.classForCoder
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }))

            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: { _ in
                if dismiss == true {
                    self.dismiss(animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }))
            present(alert, animated: true, completion: nil)
        } else {
            action()
        }
    }
}


//MARK: - Base Extention
extension BottomPopupViewController : BaseView , NVActivityIndicatorViewable{
    func showLoader() {
        self.startAnimating()
    }
    
    func hideLoader() {
        self.stopAnimating()
    }
    
    func showError(error : String) {
        self.showMessage(title: "Error".localized, sub: error, type: .error, layout: .messageView)
    }
    
    func showSuccess(title : String,massage : String) {
        self.showMessage(title: title, sub: massage, type: .success, layout: .messageView)
    }
    
    func showNoInternetConnection(action: @escaping (()->())) {
        let alert = UIAlertController(title: "Connection error".localized, message: "There was a connection error, make sure you have an internet connection and try again".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again".localized, style: UIAlertAction.Style.default,handler: { _ in
            action()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

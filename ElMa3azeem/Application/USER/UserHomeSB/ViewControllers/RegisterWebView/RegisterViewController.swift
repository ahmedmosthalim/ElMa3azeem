//
//  RegisterViewController.swift
//  ElMa3azeem
//
//  Created by Ahmed Mostafa on 21/12/2022.
//


import UIKit
import WebKit

protocol RegisterProtocol {
    func onSuccess()
}

class RegisterViewController: UIViewController {
    // MARK: - Outlets -

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewTitlw: UILabel!

    // MARK: - Properities -

    enum ScreenResion {
        case delegate
        case provider

        var fullURL: String {
            switch self {
            case .delegate:
                return URLs.BASE + "/delegate_join_request"
            case .provider:
                return URLs.BASE + "/stores_dashboard"
            }
        }

        var fullRegisterURL: String {
            switch self {
            case .delegate:
                return URLs.BASE + "/delegate_join_request/login"
            case .provider:
                return URLs.BASE + "/stores_dashboard/register"
            }
        }

        var viewTitle: String {
            switch self {
            case .delegate:
                return "Register as a delegate".localized
            case .provider:
                return "Register as a family".localized
            }
        }

        var successState: String {
            return fullURL + "/success"
        }
    }

    var delegate: RegisterProtocol?
    var registerType: ScreenResion = .provider

    // MARK: - Overriden Methods -

    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        viewTitlw.text = registerType.viewTitle
        webView.load(goToRegister(url: registerType.fullRegisterURL))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    // MARK: - Networking -

    private func goToRegister(url: String) -> URLRequest {
        let stringURL = url
        print(url)
        guard let url = URL(string: stringURL) else { return URLRequest(url: URL(string: "")!) }
        let request = URLRequest(url: url)
        return request
    }

    // MARK: - Actions -

    @IBAction func backAction(_ sender: Any) {
        if webView.canGoBack == false {
            navigationController?.popViewController(animated: true)
        } else {
            webView.goBack()
        }
    }
}

extension RegisterViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url?.absoluteString))")

        if webView.url?.absoluteString == registerType.successState {
            navigationController?.popViewController(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                self.delegate?.onSuccess()
            })
            return
        }
    }
}

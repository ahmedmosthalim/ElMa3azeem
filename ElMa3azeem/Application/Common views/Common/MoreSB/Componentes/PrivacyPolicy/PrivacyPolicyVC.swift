//
//  PrivacyPolicyVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/11/2022.
//

import UIKit

class PrivacyPolicyVC: BaseViewController {
    enum ScreenType {
        case privacyPolicy
        case termsAndConditions
        case aboutUs

        var screenTitle: String {
            switch self {
            case .privacyPolicy:
                return "Privacy policy".localized
            case .termsAndConditions:
                return "Terms and Conditions".localized
            case .aboutUs:
                return "About us".localized
            }
        }
    }

    // MARK: - OutLets

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var PrivacyPolicyText: UITextView!

    var screenType: ScreenType = .aboutUs

    // MARK: - LifeCycle Events

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.hideTabbar()
        viewTitle.text = screenType.screenTitle
        switch screenType {
        case .privacyPolicy:
            policy()
        case .termsAndConditions:
            terms()
        case .aboutUs:
            getAboutUs()
        }
        view.layoutSubviews()
    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension PrivacyPolicyVC {
    func policy() {
        showLoader()
        MoreNetworkRouter.policy.send(GeneralModel<TermsAndPolicy>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.policy()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.PrivacyPolicyText.text = data.data?.policy
//                    self.PrivacyPolicyTextHight.constant = self.PrivacyPolicyText.contentSize.height
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func terms() {
        showLoader()
        MoreNetworkRouter.terms.send(GeneralModel<TermsAndPolicy>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.terms()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.PrivacyPolicyText.text = data.data?.terms
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func getAboutUs() {
        showLoader()
        MoreNetworkRouter.about.send(GeneralModel<TermsAndPolicy>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.terms()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.PrivacyPolicyText.text = data.data?.about
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}

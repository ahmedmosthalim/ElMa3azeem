//
//  TermsAndConditionsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/11/2022.
//

import UIKit

class TermsAndConditionsVC: BaseViewController {
    
    //MARK: - OutLets
    @IBOutlet weak var PrivacyPolicyTextHught: NSLayoutConstraint!
    @IBOutlet weak var PrivacyPolicyText: UITextView!
    
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.hideTabbar()
        PrivacyPolicyTextHught.constant = PrivacyPolicyText.contentSize.height
        terms()
    }
    
    
    
    //MARK: - Logic
    
    
    
    //MARK: - Networking
    func terms() {
        self.showLoader()
        MoreNetworkRouter.terms.send(GeneralModel<TermsAndPolicy>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.terms()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.PrivacyPolicyText.text = data.data?.terms
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

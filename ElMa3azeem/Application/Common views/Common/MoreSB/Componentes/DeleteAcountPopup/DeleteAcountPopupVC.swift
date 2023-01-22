//
//  DeleteAcountPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 05/11/2022.
//

import UIKit
import BottomPopup
import NVActivityIndicatorView


class DeleteAcountPopupVC: BottomPopupViewController{

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.4 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func DeleteAction(_ sender: Any) {
        deleteProfile()
    }
    
    @IBAction func backActionAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: - API
extension DeleteAcountPopupVC {
    func deleteProfile() {
        self.showLoader()
        MoreNetworkRouter.deleteProfile.send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.deleteProfile()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
                    let nav = CustomNavigationController(rootViewController: vc)
                    MGHelper.changeWindowRoot(vc: nav)
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

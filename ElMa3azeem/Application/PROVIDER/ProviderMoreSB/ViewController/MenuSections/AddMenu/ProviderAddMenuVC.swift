//
//  AddMenuVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import UIKit

class ProviderAddMenuVC: BaseViewController {
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var menuArabicNameTf: AppTextFieldStyle!
    @IBOutlet weak var menuEnglishNameTf: AppTextFieldStyle!

    var screenReason: ScreenReason = .addNew
    var menuData: MenuModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        switch screenReason {
        case .addNew:
            viewTitleLbl.text = "Add menu".localized
        case .edit:
            viewTitleLbl.text = "Edit menu".localized
            setuMenuData(menu: menuData)
        }
    }

    // MARK: - LOGIC

    private func validateData(nameAr: String, nameEn: String) throws {
        try ValidationService.validate(nameAr: nameAr)
//        try ValidationService.validate(nameEn: nameEn)
    }

    private func setuMenuData(menu: MenuModel?) {
        menuArabicNameTf.text = menu?.nameAr
        menuEnglishNameTf.text = menu?.nameEn
    }

    // MARK: - NAVIGATION

    func navigateToAddMenuSuccessfullyPopup(reasone: ScreenReason) {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        switch screenReason {
        case .addNew:
            vc.titleMessage = .addMenuSuccessfully
        case .edit:
            vc.titleMessage = .updateMenuSuccessfully
        }

        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: ProviderMenuSectionVC.self)
        }
        present(vc, animated: true, completion: nil)
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewMenuAction(_ sender: Any) {
        do {
            try validateData(nameAr: menuArabicNameTf.text ?? "", nameEn: menuEnglishNameTf.text ?? "")
            
            switch screenReason {
            case .addNew:
                addMenu(nameAr: menuArabicNameTf.text ?? "", nameEn: menuEnglishNameTf.text ?? "")
            case .edit:
                updateMenu(menuID: menuData?.id ?? 0, nameAr: menuArabicNameTf.text ?? "", nameEn: menuEnglishNameTf.text ?? "")
            }

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

extension ProviderAddMenuVC {
    func addMenu(nameAr: String, nameEn: String) {
        showLoader()
        ProviderMoreRouter.addMenu(nameAr: nameAr, nameEn: nameEn).send(GeneralModel<MenuModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addMenu(nameAr: nameAr, nameEn: nameEn)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.navigateToAddMenuSuccessfullyPopup(reasone: .addNew)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func updateMenu(menuID: Int, nameAr: String, nameEn: String) {
        showLoader()
        ProviderMoreRouter.updateMenu(menuID: menuID, nameAr: nameAr, nameEn: nameEn).send(GeneralModel<MenuModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addMenu(nameAr: nameAr, nameEn: nameEn)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.navigateToAddMenuSuccessfullyPopup(reasone: .edit)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

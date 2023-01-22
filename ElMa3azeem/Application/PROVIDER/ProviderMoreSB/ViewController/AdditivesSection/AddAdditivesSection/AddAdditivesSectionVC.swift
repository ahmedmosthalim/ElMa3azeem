//
//  AddAdditivesSectionVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 20/11/2022.
//

import UIKit

class ProviderAddAdditiveSectionVC: BaseViewController {
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var sectionArabicNameTf: AppTextFieldStyle!
    @IBOutlet weak var sectionEnglishNameTf: AppTextFieldStyle!

    var screenReason: ScreenReason = .addNew
    var additionData: AdditionModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        switch screenReason {
        case .addNew:
            viewTitleLbl.text = "Add product addition section".localized
        case .edit:
            viewTitleLbl.text = "Edit product addition section".localized
            setuAdditionData(addition: additionData)
        }
    }

    // MARK: - LOGIC

    private func validateData(nameAr: String, nameEn: String) throws {
        try ValidationService.validate(nameAr: nameAr)
//        try ValidationService.validate(nameEn: nameEn)
    }

    private func setuAdditionData(addition: AdditionModel?) {
        sectionArabicNameTf.text = addition?.nameAr
        sectionEnglishNameTf.text = addition?.nameEn
    }

    // MARK: - NAVIGATION

    func navigateToAddAdditionSuccessfullyPopup(reasone: ScreenReason) {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        switch screenReason {
        case .addNew:
            vc.titleMessage = .addAdditionSuccessfully
        case .edit:
            vc.titleMessage = .updateAdditionSuccessfully
        }
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: ProviderAdditivesSectionVC.self)
        }
        present(vc, animated: true, completion: nil)
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addNewMenuAction(_ sender: Any) {
        do {
            try validateData(nameAr: sectionArabicNameTf.text ?? "", nameEn: sectionEnglishNameTf.text ?? "")

            switch screenReason {
            case .addNew:
                addAddition(nameAr: sectionArabicNameTf.text ?? "", nameEn: sectionEnglishNameTf.text ?? "")
            case .edit:
                updateAddition(additionID: additionData?.id ?? 0, nameAr: sectionArabicNameTf.text ?? "", nameEn: sectionEnglishNameTf.text ?? "")
            }

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

extension ProviderAddAdditiveSectionVC {
    func addAddition(nameAr: String, nameEn: String) {
        showLoader()
        ProviderMoreRouter.addAddition(nameAr: nameAr, nameEn: nameEn).send(GeneralModel<AdditionModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addAddition(nameAr: nameAr, nameEn: nameEn)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.navigateToAddAdditionSuccessfullyPopup(reasone: .addNew)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func updateAddition(additionID: Int, nameAr: String, nameEn: String) {
        showLoader()
        ProviderMoreRouter.updateAddition(additionID: additionID, nameAr: nameAr, nameEn: nameEn).send(GeneralModel<AdditionModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addAddition(nameAr: nameAr, nameEn: nameEn)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.navigateToAddAdditionSuccessfullyPopup(reasone: .edit)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

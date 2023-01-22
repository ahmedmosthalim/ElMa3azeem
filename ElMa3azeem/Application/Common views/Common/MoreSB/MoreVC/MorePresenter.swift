//
//  MorePresenter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Foundation
import UIKit

protocol MoreView: BaseView {
    func updateView()
    func openAppStore()
    func logOutAction()
    func fitchDataSuccess(user: UserModel?)
    func fitchDataSuccess(provider: StoreDetailsData?)
}

protocol MoreCellView {
    func setImage(imageName: String)
    func setTitle(title: String)
}

protocol MorePresenter {
    func viewDidLoad()

    // AccountInformation
    func AccountInformationArrayCount() -> Int
    func configureAccountInfo(cell: MoreCellView, forRow row: Int)

    // GeneralSetting
    func GeneralSettingArrayCount() -> Int
    func configureGeneralSetting(cell: MoreCellView, forRow row: Int)

    // GeneralInformation
    func generalInformationArrayCount() -> Int
    func configureGeneralInformation(cell: MoreCellView, forRow row: Int)

    // router
    func selectItem(index: Int, section: String)
    func navigateToNotification()

    // api
    func getProfile()
    func getProviderProfile()
}

class MorePresenterImplementation: MorePresenter {
    fileprivate weak var view: MoreView?
    internal let router: MoreRouter
    internal let interactor: MoreInteractor

    private var AccountInformationArray = [MoreCellModel]()
    private var generalSettingArray = [MoreCellModel]()
    private var generalInfoArray = [MoreCellModel]()
    private var telegrameLink = String()

    init(view: MoreView, router: MoreRouter, interactor: MoreInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func viewDidLoad() {
        // commen
        switch defult.shared.user()?.user?.accountType {
        case .user:
            setupUserDate()

        case .delegate:
            setupDelegateDate()

        case .provider:
            setupProviderDate()

        case .unknown:
            setupUserDate()
        case .none:
            setupUserDate()
        }

        view?.updateView()
    }

    private func setupUserDate() {
        // Personal information
        AccountInformationArray.append(MoreCellModel(title: "Edit my account".localized, image: "profile"))
        AccountInformationArray.append(MoreCellModel(title: "Favorite".localized, image: "favo"))
        AccountInformationArray.append(MoreCellModel(title: "Wallet".localized, image: "wallet"))
        AccountInformationArray.append(MoreCellModel(title: "Saved location".localized, image: "addreess"))
        AccountInformationArray.append(MoreCellModel(title: "Complaints submitted".localized, image: "complaints"))

        // General Settings
        generalSettingArray.append(MoreCellModel(title: "About us".localized, image: "about-us"))
        generalSettingArray.append(MoreCellModel(title: "Connect with us".localized, image: "contact-us"))
        generalSettingArray.append(MoreCellModel(title: "Terms and Conditions".localized, image: "terms"))
        generalSettingArray.append(MoreCellModel(title: "App language".localized, image: "translation"))
        generalSettingArray.append(MoreCellModel(title: "Join as a delegate".localized, image: "join-delegate"))
        generalSettingArray.append(MoreCellModel(title: "Join as a family".localized, image: "join-family"))

        if defult.shared.getData(forKey: .token) != "" && defult.shared.getData(forKey: .token) != nil {
            generalSettingArray.append(MoreCellModel(title: "Logout".localized, image: "logout"))
        }else{
            generalSettingArray.append(MoreCellModel(title: "Login".localized, image: ""))
        }
    }

    private func setupDelegateDate() {
        // Personal information
        AccountInformationArray.append(MoreCellModel(title: "Wallet".localized, image: "wallet"))
        AccountInformationArray.append(MoreCellModel(title: "Reviews".localized, image: "comments"))

        // General Settings

        // General Settings
        generalSettingArray.append(MoreCellModel(title: "About us".localized, image: "about-us"))
        generalSettingArray.append(MoreCellModel(title: "Connect with us".localized, image: "contact-us"))
        generalSettingArray.append(MoreCellModel(title: "Terms and Conditions".localized, image: "terms"))
        generalSettingArray.append(MoreCellModel(title: "App language".localized, image: "translation"))
        if defult.shared.getData(forKey: .token) != "" && defult.shared.getData(forKey: .token) != nil {
            generalSettingArray.append(MoreCellModel(title: "Logout".localized, image: "logout"))
        }
    }

    private func setupProviderDate() {
        // Personal information
        AccountInformationArray.append(MoreCellModel(title: "Edit my account".localized, image: "profile"))
        AccountInformationArray.append(MoreCellModel(title: "Store Settings".localized, image: "store"))
        AccountInformationArray.append(MoreCellModel(title: "Store branches".localized, image: "branches"))
        if defult.shared.provider()?.viewPackages == true
        {
            AccountInformationArray.append(MoreCellModel(title: "Subscription details".localized, image: "packages"))
        }

        AccountInformationArray.append(MoreCellModel(title: "Menu sections".localized, image: "menu_sections"))
        AccountInformationArray.append(MoreCellModel(title: "Product additions sections".localized, image: "product_additions"))
        AccountInformationArray.append(MoreCellModel(title: "Finance".localized, image: "wallet"))
        AccountInformationArray.append(MoreCellModel(title: "Reviews".localized, image: "comments"))

//        AccountInformationArray.append(MoreCellModel(title: "User comments".locشalized, image: "comments"))

        // General Settings
        generalSettingArray.append(MoreCellModel(title: "About us".localized, image: "about-us"))
        generalSettingArray.append(MoreCellModel(title: "Connect with us".localized, image: "contact-us"))
        generalSettingArray.append(MoreCellModel(title: "Terms and Conditions".localized, image: "terms"))
        generalSettingArray.append(MoreCellModel(title: "App language".localized, image: "translation"))
        generalSettingArray.append(MoreCellModel(title: "Join as a delegate".localized, image: "join-delegate"))
        if defult.shared.getData(forKey: .token) != "" && defult.shared.getData(forKey: .token) != nil {
            generalSettingArray.append(MoreCellModel(title: "Logout".localized, image: "logout"))
        }
    }

    // MARK: - API

    func getProfile() {
        view?.showLoader()
        interactor.getProofile { [weak self] data, error in
            guard let self = self else { return }
            self.view?.hideLoader()
            if let error = error {
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.view?.showNoInternetConnection { [weak self] in
                        self?.getProfile()
                    }
                } else {
                    self.view?.showError(error: error.localizedDescription)
                }
            } else {
                guard let data = data else { return }
                if data.key == ResponceStatus.success.rawValue {
                    self.view?.fitchDataSuccess(user: data.data)
                    self.telegrameLink = data.data?.telegram ?? ""
                    defult.shared.saveUser(user: data.data)
                } else {
                    self.view?.showError(error: data.msg)
                }
            }
        }
    }

    func getProviderProfile() {
        view?.showLoader()
        ProviderMoreRouter.getProviderProfile.send(GeneralModel<StoreDetailsData>.self) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.view?.showNoInternetConnection { [weak self] in
                        self?.getProviderProfile()
                    }
                } else {
                    self.view?.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.view?.fitchDataSuccess(provider: response.data)
                    defult.shared.saveProvider(provider: response.data)
                } else {
                    self.view?.showError(error: response.msg)
                }
            }
        }
    }

    // MARK: - Account Information

    func AccountInformationArrayCount() -> Int {
        return AccountInformationArray.count
    }

    func configureAccountInfo(cell: MoreCellView, forRow row: Int) {
        let item = AccountInformationArray[row]
        cell.setImage(imageName: item.image)
        cell.setTitle(title: item.title)
    }

    func navigateToEditProfile() {
        router.navigateToEditProfile()
    }

    // MARK: - General Setting

    func GeneralSettingArrayCount() -> Int {
        return generalSettingArray.count
    }

    func configureGeneralSetting(cell: MoreCellView, forRow row: Int) {
        let item = generalSettingArray[row]
        cell.setImage(imageName: item.image)
        cell.setTitle(title: item.title)
    }

    // MARK: - General Info

    func generalInformationArrayCount() -> Int {
        return generalInfoArray.count
    }

    func configureGeneralInformation(cell: MoreCellView, forRow row: Int) {
        let item = generalInfoArray[row]
        cell.setImage(imageName: item.image)
        cell.setTitle(title: item.title)
    }

    // MARK: - Router

    func selectItem(index: Int, section: String) {
        if section == "AboutAccount" {
            let item = AccountInformationArray[index]
            switch item.title {
            case "Edit my account".localized:
                router.navigateToEditProfile()
            case "Favorite".localized:
                router.navigateToFavorite()
            case "Wallet".localized:
                router.navigateToWallet()
            case "Saved location".localized:
                router.navigateToSaverAddress()
            case "Complaints submitted".localized:
                router.navigateToComplaints()
            case "Reviews".localized:
                router.navigateToUserComment()
            case "Store Settings".localized:
                router.navigateToStoreSetting()
            case "Store branches".localized:
                router.navigateToProviderStoreBranches()
            case "Menu sections".localized:
                router.navigateToProviderMenuSection()
            case "Product additions sections".localized:
                router.navigateToProviderAdditionsSections()
            case "Subscription details".localized:
                router.navigateToProviderPackage()
            case "Finance".localized:
                router.navigateToProviderFinance()

            default:
                print("outOfRanhe")
            }
        } else if section == "generalSetting" {
            let item = generalSettingArray[index]
            switch item.title {
            case "About us".localized:
                router.navigateToAboutUs()
            case "Connect with us".localized:
                router.navigateToContuctUs()
            case "Terms and Conditions".localized:
                router.navigateToTermsAndConditions()
            case "App language".localized:
                router.navigateToChangeLanguage()
            case "Join as a delegate".localized:
                router.registerDelegate()
            case "Join as a family".localized:
                router.registerProvider()
            case "Logout".localized:
                view?.logOutAction()
            case "Login".localized:
                router.navigateToLogin()

            case "Notification tone".localized:
                print("not comlete")
            case "Notification settings".localized:
                router.navigateToNotificationSetting()

            default:
                print("outOfRanhe")
            }
        } else {
            let item = generalInfoArray[index]
            switch item.title {
            case "Privacy policy".localized:
                router.navigateToPrivacyPolicy()

            case "Rate the app".localized:
                view?.openAppStore()

            case "Contact us on Telegram".localized:
                SocialMedia.shared.openUrl(url: telegrameLink)
            default:
                print("outOfRange")
            }
        }
    }

    func navigateToNotification() {
        router.navigateToNotification()
    }
}

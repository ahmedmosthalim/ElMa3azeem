//
//  MoreRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

protocol MoreRouter {
    func navigateToEditProfile()
    func navigateToFavorite()
    func navigateToSaverAddress()
    func navigateToComplaints()
    func navigateToWallet()
    func navigateToUserComment()
    func navigateToStoreSetting()
    func navigateToProviderStoreBranches()
    func navigateToProviderMenuSection()
    func navigateToProviderAdditionsSections()
    func navigateToProviderPackage()
    func navigateToProviderFinance()

    func navigateToNotification()
    func navigateToNotificationSetting()
    func navigateToChangeLanguage()

    func navigateToAboutUs()
    func navigateToContuctUs()
    func navigateToPrivacyPolicy()
    func navigateToTermsAndConditions()
    func navigateToLogin()
    func registerDelegate()
    func registerProvider()
}

class MoreRouterImplementation: MoreRouter {
    fileprivate weak var MoreViewController: MoreViewController?

    init(MoreViewController: MoreViewController) {
        self.MoreViewController = MoreViewController
    }

    // MARK: - Account Information -

    func navigateToEditProfile() {
        let vc = AppStoryboards.More.instantiate(EditProfleVC.self)
        vc.isSocialLogin = false
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToFavorite() {
        let vc = AppStoryboards.More.instantiate(FavoriteVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToSaverAddress() {
        let vc = AppStoryboards.Order.instantiate(SavedLocationVC.self)
        vc.previousVC = .moreVC
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToComplaints() {
        let vc = AppStoryboards.More.instantiate(ComplaintsVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToWallet() {
        let vc = AppStoryboards.More.instantiate(WalletVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToUserComment() {
        let vc = AppStoryboards.More.instantiate(UserCommentVC.self)
        vc.isFromMore = true
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToStoreSetting() {
        let vc = AppStoryboards.ProviderMore.instantiate(StoreSettingVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToProviderStoreBranches() {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderStoreBranchesVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToProviderMenuSection() {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderMenuSectionVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToProviderAdditionsSections() {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderAdditivesSectionVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToProviderPackage() {
        let vc = AppStoryboards.ProviderPackage.instantiate(SubscriptionPackagesVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToProviderFinance() {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderFinanceVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - General Setting -

    func navigateToNotification() {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToNotificationSetting() {
        let vc = AppStoryboards.More.instantiate(NotificationSettingVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToChangeLanguage() {
        let vc = AppStoryboards.More.instantiate(ChangeLanguageViewController.self)
        let configurator = ChangeLanguageConfiguratorImplementation()
        configurator.configure(ChangeLanguageViewController: vc)
        MoreViewController?.present(vc, animated: true)
    }

    // MARK: - General Info -

    func navigateToAboutUs() {
        let vc = AppStoryboards.More.instantiate(PrivacyPolicyVC.self)
//        let configurator = AboutUsConfiguratorImplementation()
//        configurator.configure(AboutUsViewController: vc)
        vc.screenType = .aboutUs
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToContuctUs() {
        let vc = AppStoryboards.More.instantiate(ContuctUsVC.self)
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToPrivacyPolicy() {
        let vc = AppStoryboards.More.instantiate(PrivacyPolicyVC.self)
        vc.screenType = .privacyPolicy
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToTermsAndConditions() {
        let vc = AppStoryboards.More.instantiate(PrivacyPolicyVC.self)
        vc.screenType = .termsAndConditions
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToLogin() {
        let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
        self.MoreViewController?.tabBarController?.hideTabbar()
//        vc.isVisitor = true
//        vc.visitorView = MoreViewController?.classForCoder
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    func registerDelegate() {
        let vc = AppStoryboards.Home.instantiate(RegisterViewController.self)
        vc.registerType = .delegate
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func registerProvider() {
        let vc = AppStoryboards.Home.instantiate(RegisterViewController.self)
        vc.registerType = .provider
        MoreViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

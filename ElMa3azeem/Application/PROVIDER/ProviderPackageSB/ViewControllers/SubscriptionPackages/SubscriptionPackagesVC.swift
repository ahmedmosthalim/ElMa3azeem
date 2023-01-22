//
//  SubscriptionPackagesVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/11/2022.
//

import UIKit

class SubscriptionPackagesVC: BaseViewController {
    
    @IBOutlet weak var subscribeIcon        : UIImageView!
    
    @IBOutlet weak var subscribeTitle       : UILabel!
    @IBOutlet weak var subscribeDescription : UILabel!
    
    @IBOutlet weak var subsribedView        : GradientView!
    
    @IBOutlet weak var tableView            : UITableView!
    
    @IBOutlet weak var subscribButton       : MainButton!
    @IBOutlet weak var unsubscribeButton    : UIButton!

    var currentPackage  : ProviderPackagesModel?
    var selectedPackage : ProviderPackagesModel?
    var packageArray    = [ProviderPackagesModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // YOU Should Run my Package for example to set data
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    private func setupView() {
        getPackages()
        tableViewConfigration()
    }

    private func tableViewConfigration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubscriptionPackagesCell", bundle: nil), forCellReuseIdentifier: "SubscriptionPackagesCell")
    }

    // MARK: - NAVIGATION

    private func navigateToPaymentType() {
        let vc = AppStoryboards.ProviderPackage.instantiate(PackagePaymentTypeVC.self)
        present(vc, animated: true)
    }

    // MARK: - NAVIGATION

    private func redirectToCompletePayment(payment: PaymentMethod) {
        if payment.key == "wallet" {
            navigateToWalletPaymentPopup(payment: payment)
        } else {
            navigateToOnlinePaymentPopup()
        }
    }

    func navigateToOnlinePaymentPopup() {
        
        let vc = AppStoryboards.More.instantiate(PaymentWebViewVC.self)
        
        vc.planID = String(describing: selectedPackage?.id ?? 0)
        vc.PaymentStatus = "subscription"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWalletPaymentPopup(payment: PaymentMethod) {
        let vc = AppStoryboards.Order.instantiate(PayFromWallerVC.self)
        vc.price = selectedPackage?.price ?? ""
        vc.walletPayment = { [weak self] in
            guard let self = self else { return }
            self.payWithWallet(packageID: self.selectedPackage?.id ?? 0, paymentType: payment.key)
        }
        present(vc, animated: true, completion: nil)
    }

    private func navigateToSuccessPopup() {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)
        vc.titleMessage = .packageSubscribeSuccessfully
        vc.subTitleMessage = .packageSubscribeSuccessfully
        vc.backToHome = {
            let home = AppStoryboards.ProviderHome.instantiate(CustomTabBarController.self)
            MGHelper.changeWindowRoot(vc: home)
        }
        present(vc, animated: true)
    }

    // MARK: - ACTIONS

    @IBAction func payAction(_ sender: Any) {
        guard let package = packageArray.first(where: { $0.isSelected == true }) else {
            showError(error: "Please select package first".localized)
            return
        }

        selectedPackage = package

        let vc = AppStoryboards.ProviderPackage.instantiate(PackagePaymentTypeVC.self)
        vc.didSelectPaymentWay = { [weak self] paymentWay in
            guard let self = self else { return }
            self.subscribePackage(packageID: self.selectedPackage?.id ?? 0, paymentType: paymentWay)
        }
        present(vc, animated: true)
    }

    @IBAction func unsubscribeButtonWasPressed(_ sender: UIButton) {
        let vc = AppStoryboards.ProviderPackage.instantiate(UnSubscribePopVC.self)
        vc.unsubscribe = { [weak self] in
            guard let self = self else { return }
            self.unSubscribePackake(planID: self.currentPackage?.id ?? 0)
        }
        present(vc, animated: true)
    }

    @IBAction func backWasPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Extension

extension SubscriptionPackagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionPackagesCell", for: indexPath) as! SubscriptionPackagesCell
        cell.configCell(package: packageArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        packageArray.mapInPlace({ $0.isSelected = false })
        packageArray[indexPath.row].isSelected = true
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SubscriptionPackagesVC {
    func getPackages() {
        showLoader()
        ProviderPackagesRouter.providerPackages.send(GeneralModel<[ProviderPackagesModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getPackages()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if !(response.data?.isEmpty ?? false) {
                        self.subsribedView.isHidden = true
                        self.subscribButton.isHidden = false
                        self.unsubscribeButton.isHidden = true
                        self.packageArray.append(contentsOf: response.data ?? [])
                        self.tableView.reloadData()

                        guard let package = response.data?.first(where: { $0.subscribed == true }) else { return }
                        self.currentPackage = package
                        self.subsribedView      .isHidden = false
                        self.subscribButton     .isHidden = true
                        self.unsubscribeButton  .isHidden = false
                        self.subscribeIcon      .setImage(image: package.logo)
                        self.subscribeTitle     .text = "\("You are subscribed to".localized) \(package.name)"
                        self.subscribeDescription.text = "\("Subscription will expire".localized) \(package.expireDate)"
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func payWithWallet(packageID: Int, paymentType: String) {
        showLoader()
        ProviderPackagesRouter.payPackageWithWallet(planID: packageID).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.payWithWallet(packageID: packageID, paymentType: paymentType)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.navigateToSuccessPopup()
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func subscribePackage(packageID: Int, paymentType: PaymentMethod) {
        showLoader()
        ProviderPackagesRouter.subscribePackage(planID: packageID, paymentType: paymentType.key).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.subscribePackage(packageID: packageID, paymentType: paymentType)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.redirectToCompletePayment(payment: paymentType)
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func unSubscribePackake(planID: Int) {
        showLoader()
        ProviderPackagesRouter.removeSubscription(planID: planID).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.unSubscribePackake(planID: planID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.subsribedView.isHidden = true
                    self.subscribButton.isHidden = false
                    self.unsubscribeButton.isHidden = true
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

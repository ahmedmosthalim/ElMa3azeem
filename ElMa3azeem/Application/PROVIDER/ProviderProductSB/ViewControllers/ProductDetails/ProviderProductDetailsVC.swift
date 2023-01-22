//
//  ProviderProductDetailsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import UIKit

class ProviderProductDetailsVC: BaseViewController {
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var AvilabiltySwitch: UISwitch!
    @IBOutlet weak var productView: ProductView!
    @IBOutlet weak var productDetailsView: ProductDetailsView!
    @IBOutlet weak var productFeaturesView: ProductFeaturesView!
    @IBOutlet weak var productAdditionsView: ProductFeaturesView!

    var productID: Int?
    var productData: ProviderProductDetailsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.hideTabbar()
        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getProductDetails(id: productID)
    }

    // MARK: - CONFIRATION

    private func configView() {
        setupSwitchStyle()
    }

    private func setupData(product: ProviderProductDetailsModel?) {
        guard let product = product else { return }
        productData = product
        AvilabiltySwitch.isOn = product.available
        productView.configView(image: product.image, title: product.name, price: product.displayPrice)
        productDetailsView.configView(text: product.desc)

        productFeaturesView.configView(viewType: .features, model: product.group ?? [])
        productFeaturesView.isHidden = product.productType == .simple
        productFeaturesView.isHidden = product.group?.isEmpty ?? false

        productAdditionsView.configView(viewType: .additions, model: product.productAdditiveCategories ?? [])
        productAdditionsView.isHidden = product.productAdditiveCategories?.isEmpty ?? false
    }

    private func setupSwitchStyle() {
        AvilabiltySwitch.layer.cornerRadius = AvilabiltySwitch.frame.height / 2.0
        AvilabiltySwitch.onTintColor = .systemGreen
        AvilabiltySwitch.backgroundColor = .appColor(.StoreStateClose)
        AvilabiltySwitch.clipsToBounds = true
    }

    // MARK: - NAVIGATIONS

    private func navigateToDeletePopuop(productID: Int) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderDeleteProductPopupVC.self)
        vc.deleteProduct = { [weak self] in
            guard let self = self else { return }
            self.deleteProduct(id: productID)
        }
        present(vc, animated: true, completion: nil)
    }

    private func navigateToSuccessPopup() {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)
        vc.titleMessage = .deleteProductSuccessfuly
        vc.backButtonTitle = .backToHome
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func deleteAction(_ sender: Any) {
        navigateToDeletePopuop(productID: productID ?? 0)
    }

    @IBAction func avilabiltyAction(_ sender: Any) {
        changeProductState(id: productID)
    }

    @IBAction func editProductAction(_ sender: Any) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderAddProductVC.self)
        vc.productData = productData
        vc.screenReasone = .edit
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProviderProductDetailsVC {
    private func getProductDetails(id: Int?) {
        showLoader()
        ProviderProductRouter.productDetails(productID: id ?? 0).send(GeneralModel<ProviderProductDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getProductDetails(id: id)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.setupData(product: response.data ?? nil)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    private func changeProductState(id: Int?) {
        showLoader()
        ProviderProductRouter.changeProductState(productID: id ?? 0).send(GeneralModel<GeneralData>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.changeProductState(id: id)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: "Product state changed successfully".localized)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func deleteProduct(id: Int) {
        showLoader()
        ProviderProductRouter.deleteProduct(productID: id).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.deleteProduct(id: id)
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
}

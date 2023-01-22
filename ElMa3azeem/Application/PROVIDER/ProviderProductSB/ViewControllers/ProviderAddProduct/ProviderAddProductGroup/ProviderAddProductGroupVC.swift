//
//  ProviderAddProductGroupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class ProviderAddProductGroupVC: BaseViewController {
    @IBOutlet weak var groupsTableView      : UITableView!

    var productDetails                      : ProviderProductDetailsModel?
    var selectedGroup                       = [AddProductGroupModel]()

    var screenReasone: ScreenReason         = .addNew
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        switch screenReasone {
        case .addNew:
            break
        case .edit:
            setupViewToEdit()
        }

        tableViewConfigration()
    }

    private func tableViewConfigration() {
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupsTableView.registerCell(type: ProviderAddProductGroupCell.self)
    }

    private func setupViewToEdit() {
        productDetails?.group?.enumerated().forEach({ index, group in

            selectedGroup.append(AddProductGroupModel(id: group.id, features: productDetails?.features ?? [],
                                                      price: group.price ?? "",
                                                      qty: String(group.inStockQty ?? 0),
                                                      discountPrice: group.priceAfterDiscount ?? "",
                                                      from: group.discountFrom?.stringToDate ?? Date()
                                                      , to: group.discountTo?.stringToDate ?? Date()))

            selectedGroup.enumerated().forEach { _, feature in
                group.propreties?.forEach({ groupFeature in
                    let featureIndex = feature.features.firstIndex(where: { $0.id == groupFeature.featureID }) ?? 0
                    selectedGroup[index].features[featureIndex].selectedProperity = Properity(id: groupFeature.id ?? 0, name: groupFeature.name?.name ?? "", featureID: groupFeature.featureID, createdAt: groupFeature.createdAt ?? "", updatedAt: groupFeature.updatedAt ?? "", isSelected: true)
                })
            }

        })
    }

    // MARK: - LOGIC

    func validate() {
        do {
            var jsonArray = [AddProductGroupAPIModel]()
            try selectedGroup.enumerated().forEach { index, group in
                try ValidationService.validate(group: group)
                
                jsonArray.append(AddProductGroupAPIModel(id: group.id, properties: [],
                                                         price: group.price,
                                                         qty: group.qty,
                                                         discountPrice: group.discountPrice == "" ? "" : group.discountPrice,
                                                         from: group.discountPrice == "" ? "" : group.from.apiDate(),
                                                         to: group.discountPrice == "" ? "" : group.to.apiDate()))

                
                for item in group.features {
                    jsonArray[index].properties.append(item.selectedProperity?.id ?? 0)
                }
            }

            addProductGroup(productID: productDetails?.id ?? 0, productGroups: jsonArray.toString())
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    // MARK: - NAVIGATION

    func naviagteToSuccesAdd(productID: Int) {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)

        switch screenReasone {
        case .addNew:
            vc.titleMessage = .addProductSuccessfully
        case .edit:
            vc.titleMessage = .updateProductSuccessfully
        }

        vc.backButtonTitle = .back
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.navigateToProductFeature(productID: productID)
        }
        present(vc, animated: true)
    }

    func navigateToProductFeature(productID: Int) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderProductDetailsVC.self)
        vc.productID = productID
        navigationController?.pushViewController(vc: vc, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.removeViewController(ProviderAddProductGroupVC.self)
        })
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func AddGroupAction(_ sender: Any) {
        

        selectedGroup.append(AddProductGroupModel(features: productDetails?.features ?? [], price: productDetails?.price ?? "", qty: String(productDetails?.inStockQty ?? 0), discountPrice: "", from: Date(), to: Date()))
        groupsTableView.reloadData()
    }

    @IBAction func saveChangesAction(_ sender: Any) {
        if selectedGroup.isEmpty == false
        {
            validate()
        }else
        {
            showError(error: "Please Enter A group details".localized)
        }
    }
}

// MARK: - TableView Extension

extension ProviderAddProductGroupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedGroup.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ProviderAddProductGroupCell.self, for: indexPath) as! ProviderAddProductGroupCell
        if !selectedGroup.isEmpty {
            cell.deleteButton.isHidden = indexPath.row == 0
            cell.configCell(group: selectedGroup[indexPath.row], screenReasone: screenReasone /* , selectedGroup: productDetails?.group?.isEmpty ?? false == false ? productDetails?.group?[indexPath.row] : nil */ )
            cell.selectFeature = { [weak self] feaure in
                guard let self = self else { return }
                guard let index = self.selectedGroup[indexPath.row].features.firstIndex(where: { $0.id == feaure.id }) else { return }
                self.selectedGroup[indexPath.row].features[index].selectedProperity = feaure.selectedProperity
                self.groupsTableView.reloadData()
            }

            cell.deleteGroupTapped = { [weak self] in
                guard let self = self else { return }
                self.selectedGroup.remove(at: indexPath.row)
                self.groupsTableView.reloadData()
            }

            cell.updatePrice = { [weak self] price in
                guard let self = self else { return }
                self.selectedGroup[indexPath.row].price = price
            }

            cell.updateStock = { [weak self] stock in
                guard let self = self else { return }
                self.selectedGroup[indexPath.row].qty = stock
            }

            cell.updateDiscountPrice = { [weak self] price in
                guard let self = self else { return }
                self.selectedGroup[indexPath.row].discountPrice = price
            }

            cell.updateFromDate = { [weak self] date in
                guard let self = self else { return }
                self.selectedGroup[indexPath.row].from = date
            }

            cell.updateToDate = { [weak self] date in
                guard let self = self else { return }
                self.selectedGroup[indexPath.row].to = date
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - API

extension ProviderAddProductGroupVC {
    func addProductGroup(productID: Int, productGroups: String) {
        showLoader()
        ProviderProductRouter.addProductGroup(productID: productID, productGroups: productGroups).send(GeneralModel<ProviderProductDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addProductGroup(productID: productID, productGroups: productGroups)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.naviagteToSuccesAdd(productID: response.data?.id ?? 0)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func updateProductGroup(productID: Int, productGroups: String) {
        showLoader()
        ProviderProductRouter.updateProductGroup(productID: productID, productGroups: productGroups).send(GeneralModel<ProviderProductDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addProductGroup(productID: productID, productGroups: productGroups)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.naviagteToSuccesAdd(productID: response.data?.id ?? 0)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

//
//  ProviderAddProductFeaturesVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import UIKit

class ProviderAddProductFeaturesVC: BaseViewController {
    @IBOutlet weak var featureTf            : AppPickerTextFieldStyle!
    @IBOutlet weak var featuresTableView    : IntrinsicTableView!
    @IBOutlet weak var confirmView          : UIView!

    private var featuresArray = [AppFeatureModel]()
    var screenReasone: ScreenReason = .addNew
    var productData: ProviderProductDetailsModel?

    var productID = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        tableViewConfigration()
        getAppFeatures()
    }

    private func tableViewConfigration() {
        featuresTableView.delegate = self
        featuresTableView.dataSource = self
        featuresTableView.registerCell(type: ProductAddSeletedFeatureCell.self)
    }

    // MARK: - LOGIC

    private func setupViewToUpdate(product: ProviderProductDetailsModel?) {
        guard let product = product else { return }

        product.features?.forEach({ group in
            featuresArray[featuresArray.firstIndex(where: { $0.id == group.id }) ?? 0].isSelected = true
            featuresArray[featuresArray.firstIndex(where: { $0.id == group.id }) ?? 0].properties?.enumerated().forEach({ index, feature in
                group.properities?.forEach({ groupFeature in
                    if feature.id == groupFeature.id {
                        featuresArray[featuresArray.firstIndex(where: { $0.id == group.id }) ?? 0].properties?[index].isSelected = true
                    }
                })
            })
        })

        featuresTableView.reloadData()
    }

    // MARK: - NAVIGATION

    func naviagteToSuccesAdd(productData: ProviderProductDetailsModel) {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)
        switch screenReasone {
        case .addNew:
            vc.titleMessage = .addProductFeauturesSuccessfully
        case .edit:
            vc.titleMessage = .updateProductFeauturesSuccessfully
        }
        
        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.navigateToAddGroup(productData: productData)
        }

        present(vc, animated: true)
    }

    func navigateToAddGroup(productData: ProviderProductDetailsModel) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderAddProductGroupVC.self)
        vc.productDetails = productData
        vc.screenReasone = screenReasone
        navigationController?.pushViewController(vc: vc, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.removeViewController(ProviderAddProductFeaturesVC.self)
        })
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addFeatureAction(_ sender: Any) {
        let feature = featuresArray[featureTf.currentIndex]
        if featureTf.text?.isEmpty == false
        {
            if feature.isSelected == false {
                featuresArray[featureTf.currentIndex].isSelected = true
                featuresTableView.reloadData()
            } else {
                showError(error: "The selected feature added before".localized)
            }
        }else
        {
            showError(error: "Please choose at least one feature".localized)
        }

        featureTf.selectedPickerData = nil
        featureTf.text = ""
    }

    @IBAction func AddFeautures(_ sender: Any) {
        
        
        var featureJson = [FeatureApiModel]()
        
        let selectedFeatures = featuresArray.filter({$0.isSelected == true})
        
        guard !selectedFeatures.isEmpty else {
            showError(error: "Please choose at least one feature".localized)
            return
        }
        
        for feature in selectedFeatures {
            let selectedProperties = feature.properties?.filter({$0.isSelected == true}) ?? []
            guard !selectedProperties.isEmpty else {
                showError(error: "Please select one propriety at least".localized)
                return
            }
            
            let selectedAPIPropriety = selectedProperties.compactMap {
                PropertiesApiModel(id: $0.id!)
            }
            
            featureJson.append(
                FeatureApiModel(
                    featureId: feature.id,
                    properties: selectedAPIPropriety
                )
            )
        }
        
        addProductFeautures(productID: productID, productFeatures: featureJson.toString())
        
//        for _ in featuresArray {
//            guard let feature = featuresArray.first(where: { $0.isSelected == true }) else {
//                showError(error: "Please choose at least one feature".localized)
//                return
//            }
//
//            guard let _ = feature.properties?.first(where: { $0.isSelected == true }) else {
//                showError(error: "Please choose at least one property".localized)
//                return
//            }
//
//            let selectedFeature = featuresArray.filter({ $0.isSelected == true })
//
//            var featureJson = [FeatureApiModel]()
//
//            selectedFeature.enumerated().forEach { index, feature in
//                featureJson.append(FeatureApiModel(featureId: feature.id, properties: []))
//                for property in feature.properties ?? []{
//                    if property.isSelected == true {
//                        featureJson[index].properties.append(PropertiesApiModel(id: property.id ?? 0))
//                    }
//                }
//            }
//            addProductFeautures(productID: productID, productFeatures: featureJson.toString())
//        }
    }
}

// MARK: - TableView Extension

extension ProviderAddProductFeaturesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuresArray.filter({ $0.isSelected == true }).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ProductAddSeletedFeatureCell.self, for: indexPath) as! ProductAddSeletedFeatureCell
        let dataSorce = featuresArray.filter({ $0.isSelected == true })

        cell.configCell(item: dataSorce[indexPath.row])

        cell.deleteTapped = { [weak self] in
            guard let self = self else { return }
            let id = dataSorce[indexPath.row].id
            guard let index = self.featuresArray.firstIndex(where: { $0.id == id }) else { return }
            self.featuresArray[index].isSelected = false
            self.featuresArray[index].properties?.enumerated().forEach({ (propertiesIndex, data) in
                self.featuresArray[index].properties?[propertiesIndex].isSelected = false
            })

            self.featuresTableView.reloadData()
        }

        cell.addProperty = { [weak self] property in
            guard let self = self else { return }
            let id = dataSorce[indexPath.row].id
            guard let index = self.featuresArray.firstIndex(where: { $0.id == id }) else { return }

            let propertyId = property.id
            guard let propertyIndex = self.featuresArray[index].properties?.firstIndex(where: { $0.id == propertyId }) else { return }

            self.featuresArray[index].properties?[propertyIndex].isSelected = true
            self.featuresTableView.reloadData()
        }

        cell.removeProperty = { [weak self] property in
            guard let self = self else { return }

            let id = dataSorce[indexPath.row].id
            guard let index = self.featuresArray.firstIndex(where: { $0.id == id }) else { return }

            let propertyId = property.id
            guard let propertyIndex = self.featuresArray[index].properties?.firstIndex(where: { $0.id == propertyId }) else { return }

            self.featuresArray[index].properties?[propertyIndex].isSelected = false
            self.featuresTableView.reloadData()
        }

        cell.addError = { [weak self] message in
            guard let self = self else { return }
            self.showError(error: message)
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

extension ProviderAddProductFeaturesVC {
    func getAppFeatures() {
        showLoader()
        ProviderProductRouter.getAppFeatures.send(GeneralModel<[AppFeatureModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getAppFeatures()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.featuresArray = response.data ?? []
                    self.featureTf.setupData(data: self.featuresArray)

                    switch self.screenReasone {
                    case .addNew:
                        break
                    case .edit:
                        self.setupViewToUpdate(product: self.productData)
                    }

                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func addProductFeautures(productID: Int, productFeatures: String) {
        showLoader()
        ProviderProductRouter.addProductFeature(productID: productID, productFeatures: productFeatures).send(GeneralModel<ProviderProductDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addProductFeautures(productID: productID, productFeatures: productFeatures)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.naviagteToSuccesAdd(productData: response.data!)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

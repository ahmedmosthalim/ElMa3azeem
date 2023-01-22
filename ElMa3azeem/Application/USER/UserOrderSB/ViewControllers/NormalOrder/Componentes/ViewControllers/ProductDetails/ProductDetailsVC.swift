//
//  ProductDetailsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1411/2022.
//

import BottomPopup
import NVActivityIndicatorView
import SwiftMessages
import UIKit

protocol selectProductProtocol {
    func selectProduct(menuID: Int, productID: Int, productName: String, productIamge: String, productPrice: Double, groupID: Int, quantity: Int, totalPrice: Double, feature: [Feature], addition: [ProductAdditiveCategory])
}

class ProductDetailsVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height * 0.85) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }

    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!

    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var featureTableView: IntrinsicTableView!

    @IBOutlet weak var totalFeaturePriceLbl: UILabel!
    @IBOutlet weak var additionTableView: IntrinsicTableView!

    @IBOutlet weak var dismissAction    : UIButton!
    @IBOutlet weak var favorteBtn       : UIButton!
    
    
    @IBOutlet weak var additionView: UIView!
    var delegate: selectProductProtocol?
    var counter = 1

    var avilableCount   = 0
    var productURL      = String()
    var groupID         = Int()
    var productID       = Int()
    var menuID          = Int()
    var featuresArray           = [Feature]()
    var selectedFeatureArray    = [Feature]()
    var additionsArray          = [ProductAdditiveCategory]()

    var productPrice    = 0.0
    var additionPrice   = 0.0
    var totalPtice      = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getproductDetailsData(productID: productID)
    }

    func setupView() {
        counterLbl.text = "\(counter)"

        featureTableView.tableFooterView = UIView()
        featureTableView.delegate = self
        featureTableView.dataSource = self
        featureTableView.register(UINib(nibName: "FeaturesCell", bundle: nil), forCellReuseIdentifier: "FeaturesCell")

        additionTableView.tableFooterView = UIView()
        additionTableView.delegate = self
        additionTableView.dataSource = self
        additionTableView.register(UINib(nibName: "AdditionsCell", bundle: nil), forCellReuseIdentifier: "AdditionsCell")
    }

    func updateCounterAndTotlaPriceLabel() {
        getTotalPrice(productPrice: productPrice, addetionPrice: additionPrice, counter: counter)
        totalFeaturePriceLbl.text = "\(totalPtice) \(defult.shared.getAppCurrency() ?? "")"
    }

    func getTotalPrice(productPrice: Double, addetionPrice: Double, counter: Int) {
        totalPtice = (productPrice + addetionPrice) * Double(counter)
        counterLbl.text = "\(counter)"
    }

    func setupTableViewHeader(tableView: UITableView, section: Int) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        let label: UILabel = {
            let imageView = UILabel()
            return imageView
        }()
        label.text = additionsArray[section].name
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .appColor(.MainFontColor)
        headerView.addSubview(label)
        label.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 20, width: 0, height: 20)
  
        return headerView
    }

    // MARK: - Actions

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func favoriteAction(_ sender: Any) {
        favoriteApi(productId: productID)
    }

    @IBAction func increaseAction(_ sender: Any) {
        if counter < avilableCount {
            counter += 1
            updateCounterAndTotlaPriceLabel()
        } else {
            showError(error: "You cannot choose more product, the quantity is not available".localized)
        }
    }

    @IBAction func decreaseAction(_ sender: Any) {
        if counter > 1 {
            counter -= 1
            updateCounterAndTotlaPriceLabel()
        }
    }

    @IBAction func confirmAction(_ sender: Any) {
        if groupID != 0 {
            delegate?.selectProduct(menuID: menuID, productID: productID, productName: productTitle.text ?? "", productIamge: productURL, productPrice: Double(productPrice + additionPrice), groupID: groupID, quantity: counter, totalPrice: totalPtice, feature: selectedFeatureArray, addition: additionsArray)
            dismiss(animated: true)
        } else {
            showError(error: "Choose the product details first".localized)
        }
    }
}

// MARK: - TableView Extension -

extension ProductDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == featureTableView {
            return 1
        } else {
            return additionsArray.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == featureTableView {
            return featuresArray.count
        } else {
            return additionsArray[section].productAdditives.count
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if tableView == featureTableView {
            return 0
        } else {
            return 20
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == additionTableView {
            return setupTableViewHeader(tableView: additionTableView, section: section)
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == featureTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturesCell", for: indexPath) as! FeaturesCell
            cell.configCell(data: featuresArray[indexPath.row])
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionsCell", for: indexPath) as! AdditionsCell
            cell.configCell(product: additionsArray[indexPath.section].productAdditives[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == additionTableView {
            if additionsArray[indexPath.section].productAdditives[indexPath.row].isSelected == false || additionsArray[indexPath.section].productAdditives[indexPath.row].isSelected == nil {
                additionsArray[indexPath.section].productAdditives[indexPath.row].isSelected = true
                additionPrice = additionPrice + Double(additionsArray[indexPath.section].productAdditives[indexPath.row].price ?? "")!
                updateCounterAndTotlaPriceLabel()

            } else {
                additionsArray[indexPath.section].productAdditives[indexPath.row].isSelected = false
                additionPrice = additionPrice - Double(additionsArray[indexPath.section].productAdditives[indexPath.row].price ?? "")!
                updateCounterAndTotlaPriceLabel()
            }
            additionTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Delegate Extension

extension ProductDetailsVC: selectFeatureProtocol {
    func selectFeature(feature: Feature?) {
        if selectedFeatureArray.isEmpty {
            selectedFeatureArray.append(feature!)

            if selectedFeatureArray.count == featuresArray.count {
                var id = [String]()
                for fearue in selectedFeatureArray {
                    for property in fearue.properities ?? [] {
                        if property.isSelected == true {
                            id.append("\(property.id ?? 0)")
                        }
                    }
                }
                selectGroup(productID: productID, properities: id)
            }
            
        } else {
            if selectedFeatureArray.contains(where: { $0.id == feature?.id }) {
                guard let index = selectedFeatureArray.firstIndex(where: { $0.id == feature?.id }) else { return }
                selectedFeatureArray.remove(at: index)
                selectedFeatureArray.append(feature!)
            } else {
                selectedFeatureArray.append(feature!)
            }

            if selectedFeatureArray.count == featuresArray.count {
                var id = [String]()
                for fearue in selectedFeatureArray {
                    for property in fearue.properities ?? []{
                        if property.isSelected == true {
                            id.append("\(property.id ?? 0)")
                        }
                    }
                }

                selectGroup(productID: productID, properities: id)
            }
        }
    }
}

// MARK: - API Extention

extension ProductDetailsVC {
    func getproductDetailsData(productID: Int) {
        showLoader()
        CreateOrderNetworkRouter.storeProduct(productID: "\(productID)").send(GeneralModel<ProductModel>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getproductDetailsData(productID: productID)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                self.hideLoader()
                if data.key == ResponceStatus.success.rawValue {
                    self.productImage.setImage(image: data.data?.product.image ?? "", loading: true)
                    self.productTitle.text = data.data?.product.name
                    self.productURL = data.data?.product.image ?? ""
                    self.groupID = data.data?.product.group?.id ?? 0
                    
                    self.totalFeaturePriceLbl.text = "\(data.data?.product.group?.price ?? "") \(defult.shared.getAppCurrency() ?? "")"
                    self.totalFeaturePriceLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                    self.totalFeaturePriceLbl.textColor = UIColor.appColor(.MainFontColor)
                    
                    self.productPrice = Double(data.data?.product.group?.price ?? "") ?? 0
                    self.productDescription.text = data.data?.product.desc
                    self.avilableCount = data.data?.product.group?.qty ?? 0
                    
//                    self.productPriceLbl.text = "\(data.data?.product.group?.price ?? "") \(defult.shared.getAppCurrency() ?? "")"
//                    self.productPriceLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                
                    
                    if data.data?.product.features?.isEmpty == false {
                        self.featureView.isHidden = false
                        self.totalFeaturePriceLbl.attributedText = data.data?.product.displayPrice?.htmlToAttributedString
                        self.totalFeaturePriceLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                        self.featuresArray.append(contentsOf: data.data?.product.features ?? [])

                        self.featureTableView.reloadData()
                    } else {
                        self.featureView.isHidden = true
                        self.totalPtice = Double(data.data?.product.group?.price ?? "") ?? 0
                    }

                    if data.data?.product.productAdditiveCategories?.isEmpty == false {
                        self.additionView.isHidden      = true
                        self.additionTableView.isHidden = true
                        for i in 0...data.data!.product.productAdditiveCategories!.count-1
                        {
                            if data.data!.product.productAdditiveCategories![i].productAdditives.isEmpty == false
                            {
                                self.additionsArray.append(data.data!.product.productAdditiveCategories![i])
//                                self.additionsArray.append(contentsOf: data.data!.product.productAdditiveCategories! ?? [])
                                self.additionView.isHidden      = false
                                self.additionTableView.isHidden = false
                            }
                        }
                            self.additionTableView.reloadData()
                    } else {
                        self.additionView.isHidden      = true
                        self.additionTableView.isHidden = true
                    }
                    
                    if data.data?.product.isFavourite == false {
                        self.favorteBtn.backgroundColor = .appColor(.viewBackGround80)
                    }else{
                        self.favorteBtn.backgroundColor = .appColor(.MainColor)
                    }

                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func selectGroup(productID: Int, properities: [String]) {
        showLoader()

        CreateOrderNetworkRouter.selectGroup(productID: "\(productID)", properities: properities.toString()).send(GeneralModel<GroupModel>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):

                if error.localizedDescription.contains("connection") {
                    self.showNoInternetConnection {
                        self.selectGroup(productID: productID, properities: properities)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }

            case let .success(data):

                self.hideLoader()
                if data.key == ResponceStatus.success.rawValue {
                    self.totalFeaturePriceLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                    self.totalFeaturePriceLbl.text = "\(data.data?.group?.price ?? "") \(defult.shared.getAppCurrency() ?? "")"
                    self.totalFeaturePriceLbl.textColor = .appColor(.MainFontColor)
                    self.productPrice = Double(data.data?.group?.price ?? "") ?? 0
                    self.groupID = data.data?.group?.id ?? 0
                    self.avilableCount = data.data?.group?.qty ?? 0
                    self.updateCounterAndTotlaPriceLabel()
                } else {
                    self.groupID = 0
                    self.productPrice = 0
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func favoriteApi(productId : Int) {
        self.showLoader()
        CreateOrderNetworkRouter.favourite(productID: productId).send(GeneralModel<FavoriteModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.favoriteApi(productId: productId)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.data?.favorite == false  {
                        self.favorteBtn.backgroundColor = .appColor(.viewBackGround80)
                    }else{
                        self.favorteBtn.backgroundColor = .appColor(.MainColor)
                    }

                    self.showSuccess(title: "", massage: response.msg)
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
}




//
//  ProviderAddProductVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 28/11/2022.
//

import SwiftUI
import UIKit

class ProviderAddProductVC: BaseViewController {
    @IBOutlet weak var productImage         : UIImageView!
    @IBOutlet weak var productArabicNameTf  : AppTextFieldStyle!
    @IBOutlet weak var productEnglishNameTf : AppTextFieldStyle!
    @IBOutlet weak var productPriceTf       : AppTextFieldStyle!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var productPriceAfterDiscountTf: AppTextFieldStyle!
    @IBOutlet weak var menuTf: AppPickerTextFieldStyle!
    @IBOutlet weak var productDescriptionArabicTv: AppTextViewStyle!
    @IBOutlet weak var productDescriptionEnglishTv: AppTextViewStyle!
    @IBOutlet weak var productTypeTf: AppPickerTextFieldStyle!
    @IBOutlet weak var stockTf: AppPickerTextFieldStyle!
    @IBOutlet weak var quantityTf: AppTextFieldStyle!
    @IBOutlet weak var additivesTableView: IntrinsicTableView!
    @IBOutlet weak var discountView: UIStackView!
    @IBOutlet weak var discountBtn: UIButton!

    @IBOutlet weak var discountFromDate: AppPickerTextFieldStyle!
    @IBOutlet weak var discountToDate: AppPickerTextFieldStyle!

    private var productImageData: Data?
    private var isProductHasImage : Bool = false
    private let productType = [
        GeneralPicker(id: 0, title: "Simple", key: "simple"),
        GeneralPicker(id: 1, title: "Multiple", key: "multiple"),
    ]

    private let stockType = [
        GeneralPicker(id: 0, title: "In stock", key: "in"),
        GeneralPicker(id: 1, title: "Out of stock", key: "out"),
    ]

    var screenReasone: ScreenReason = .addNew
    var productData: ProviderProductDetailsModel?

    var additionData = [AdditionModel]()
    private var additionsArray = [AddProductAdditionModel]()

    private var isHaveDiscount = false {
        didSet {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.discountView.isHidden = !self.isHaveDiscount
            }
            discountBtn.setImage(UIImage(named: isHaveDiscount == true ? "circle-mark-selected" : "circle-mark-not-selected"), for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.discountView.isHidden = !self.isHaveDiscount
        }
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        discountFromDate.pickerType = .date
        discountToDate.pickerType = .date
        productTypeTf.setupData(data: productType)
        stockTf.setupData(data: stockType)
        tableViewConfigration()
        productImage.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.chooseImage()
        }

        getMenu()
        getAdditives()

        switch screenReasone {
        case .addNew:
            mainTitleLabel.text = "Add New Product".localized
            isProductHasImage = false
            break
        case .edit:
            mainTitleLabel.text = "Edit Product".localized
            isProductHasImage = true
            setupViewDataToEditProduct(product: productData)
        }
    }

    @objc private func chooseImage() {
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    private func tableViewConfigration() {
        additivesTableView.delegate = self
        additivesTableView.dataSource = self
        
        additivesTableView.registerCell(type: ProviderAddProductAdditionCell.self)
    }

    func validateProducData(productArabicName: String, productEnglishName: String, productPrice: String, productPriceAfterDiscount: String, menu: String, productDescriptionArabic: String, productDescriptionEnglish: String, productType: String, stockType: String, StockQuantity: String) throws {
        if isProductHasImage == false
        {
            let imageData = try ValidationService.validate(productPicture: productImageData)
        }
        try ValidationService.validate(productNameAr: productArabicName)
//        try ValidationService.validate(productNameEr: productEnglishName)
        try ValidationService.validate(productPricee: productPrice)
        try ValidationService.validate(selectMenu: menu)
        try ValidationService.validate(stockType: stockType)
        try ValidationService.validate(quanty: StockQuantity)
        try ValidationService.validate(productDescriptionAr: productDescriptionArabic)
//        try ValidationService.validate(productDescriptionEn: productDescriptionEnglish)
        try ValidationService.validate(productType: productType)

        if isHaveDiscount {
            try ValidationService.validate(productPriceDiscount: productPriceAfterDiscountTf.text ?? "")
            try ValidationService.validate(fromeDate: discountFromDate.selectedDate, toDate: discountToDate.selectedDate)
            try ValidationService.validate(normalPrice: productPrice, discountPrice: productPriceAfterDiscountTf.text ?? "")
        }
    }

//    @IBOutlet weak var additivesTableView: IntrinsicTableView!

    func setupViewDataToEditProduct(product: ProviderProductDetailsModel?) {
        productImage.setImage(image: product?.image ?? "")
        isProductHasImage = true
        productArabicNameTf.text = product?.nameAr ?? ""
        productEnglishNameTf.text = product?.nameEn ?? ""
        productPriceTf.text = product?.price ?? ""
        isHaveDiscount = product?.priceAfterDiscount != nil

        if isHaveDiscount {
            productPriceAfterDiscountTf.text = String(product?.priceAfterDiscount ?? "")

            discountFromDate.selectedDate = product?.discountFrom.stringToDate ?? Date()
            discountToDate.selectedDate = product?.discountTo.stringToDate ?? Date()
            discountFromDate.text = discountFromDate.selectedDate.dateToString
            discountToDate.text = discountToDate.selectedDate.dateToString
        }

        productDescriptionArabicTv.text = product?.descAr
        productDescriptionEnglishTv.text = product?.descEn

        productTypeTf.selectedPickerData = productType.first(where: { $0.key == product?.type })
        productTypeTf.text = productTypeTf.selectedPickerData?.pickerTitle.localized ?? ""

        stockTf.selectedPickerData = stockType.first(where: { $0.key == product?.inStockType })
        stockTf.text = stockTf.selectedPickerData?.pickerTitle.localized ?? ""
        quantityTf.text = String(product?.inStockQty ?? 0)
    }

    func setupAdditivesToEdit(product: ProviderProductDetailsModel?) {
        product?.productAdditiveCategories?.enumerated().forEach({ _, addition in
            if addition.productAdditives.isEmpty == false {
                addition.productAdditives.forEach { properity in
                    additionsArray.append(AddProductAdditionModel(nameAr: properity.name ?? "", nameEn: properity.nameEn ?? "", price: properity.price ?? "", additiveCategory: GeneralPicker(id: addition.id, title: addition.name, key: "")))
                }
            }
        })
        additivesTableView.reloadData()
    }

    // MARK: - NAVIGATION

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    func naviagteToSuccesAdd(productID: Int) {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)

        if productTypeTf.selectedPickerData?.pickerKey == "simple" {
            switch screenReasone {
            case .addNew:
                vc.titleMessage = .addProductSuccessfully
            case .edit:
                vc.titleMessage = .updateProductSuccessfully
            }

            vc.backButtonTitle = .back
            vc.backToHome = { [weak self] in
                guard let self = self else { return }
                self.navigateToProductDetails(productID: productID)
            }
        } else {
            switch screenReasone {
            case .addNew:
                vc.titleMessage = .addProductSuccessfullyWithFeautures
            case .edit:
                vc.titleMessage = .updateProductSuccessfullyWithFeautures
            }

            vc.backButtonTitle = .continu
            vc.backToHome = { [weak self] in
                guard let self = self else { return }
                self.navigateToProductFeature(productID: productID)
            }
        }

        present(vc, animated: true)
    }

    func navigateToProductFeature(productID: Int) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderAddProductFeaturesVC.self)
        vc.productID = productID
        vc.productData = productData
        vc.screenReasone = screenReasone
        navigationController?.pushViewController(vc: vc, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.removeViewController(ProviderAddProductVC.self)
        })
    }

    func navigateToProductDetails(productID: Int) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderProductDetailsVC.self)
        vc.productID = productID
        navigationController?.pushViewController(vc: vc, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.removeViewController(ProviderAddProductVC.self)
        })
    }

    // MARK: - ACTIONS

    @IBAction func haveDiscountAction(_ sender: Any) {
        isHaveDiscount = !isHaveDiscount
    }

    @IBAction func addAdditionAction(_ sender: Any) {
        if additionData.isEmpty == false
        {
            additionsArray.append(AddProductAdditionModel(nameAr: "", nameEn: "", price: "", additiveCategory: GeneralPicker(id: 0, title: "", key: "")))
        }else
        {
            showError(error: "There is no additions , You can Add Additions to Use this Feature".localized)
        }
        additivesTableView.reloadData()
    }

    @IBAction func addAction(_ sender: Any) {
        do {
            try validateProducData(productArabicName: productArabicNameTf.text ?? "", productEnglishName: productEnglishNameTf.text ?? "", productPrice: productPriceTf.text ?? "", productPriceAfterDiscount: productPriceAfterDiscountTf.text ?? "", menu: menuTf.text ?? "", productDescriptionArabic: productDescriptionArabicTv.text ?? "", productDescriptionEnglish: productDescriptionEnglishTv.text ?? "", productType: productTypeTf.text ?? "", stockType: stockTf.text ?? "", StockQuantity: quantityTf.text ?? "")

            var additionsJson = [AddProductAdditionToApiModel]()
            if !additionsArray.isEmpty {
                for addition in additionsArray {
                    additionsJson.append(AddProductAdditionToApiModel(nameAr: addition.nameAr, nameEn: addition.nameEn, price: Int(addition.price) ?? 0, additiveCategoryID: addition.additiveCategory.id))
                }
            }

            switch screenReasone {
            case .addNew:
                addProduct(nameAr: productArabicNameTf.text ?? "", nameEn: productEnglishNameTf.text ?? "", price: productPriceTf.text ?? "", haveDiscount: isHaveDiscount, discountPrice: productPriceAfterDiscountTf.text ?? "", from: discountFromDate.selectedDate.apiDate(), to: discountToDate.selectedDate.apiDate(), productType: productTypeTf.selectedPickerData?.pickerKey ?? "", inStockType: stockTf.selectedPickerData?.pickerKey ?? "", inStockQty: quantityTf.text ?? "", storeMenuId: menuTf.selectedPickerData?.pickerId ?? 0, descAr: productDescriptionArabicTv.text ?? "", descEn: productDescriptionEnglishTv.text ?? "", addition: !additionsJson.isEmpty ? additionsJson.toString() : "", imageData: productImageData)
            case .edit:
                updateProduct(productID: productData?.id ?? 0, nameAr: productArabicNameTf.text ?? "", nameEn: productEnglishNameTf.text ?? "", price: productPriceTf.text ?? "", haveDiscount: isHaveDiscount, discountPrice: productPriceAfterDiscountTf.text ?? "", from: discountFromDate.selectedDate.apiDate(), to: discountToDate.selectedDate.apiDate(), productType: productTypeTf.selectedPickerData?.pickerKey ?? "", inStockType: stockTf.selectedPickerData?.pickerKey ?? "", inStockQty: quantityTf.text ?? "", storeMenuId: menuTf.selectedPickerData?.pickerId ?? 0, descAr: productDescriptionArabicTv.text ?? "", descEn: productDescriptionEnglishTv.text ?? "", addition: !additionsJson.isEmpty ? additionsJson.toString() : "", imageData: productImageData)
            }

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

// MARK: - ImagePicker Delegate

extension ProviderAddProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.3)!
            productImageData = imageData
            productImage.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - TableView Extension

extension ProviderAddProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ProviderAddProductAdditionCell.self, for: indexPath) as! ProviderAddProductAdditionCell

        cell.additionSection.setupData(data: additionData)

        if !additionsArray.isEmpty {
            cell.configCell(nameAr: additionsArray[indexPath.row].nameAr, nameEn: additionsArray[indexPath.row].nameEn, price: additionsArray[indexPath.row].price, type: additionsArray[indexPath.row].additiveCategory)

            cell.updateArNameTapped = { [weak self] name in
                guard let self = self else { return }
                self.additionsArray[indexPath.row].nameAr = name
            }
            cell.updateEnNameTapped = { [weak self] name in
                guard let self = self else { return }
                self.additionsArray[indexPath.row].nameEn = name
            }
            cell.updatePriceTapped = { [weak self] price in
                guard let self = self else { return }
                self.additionsArray[indexPath.row].price = price
            }
            cell.updateCategoryTapped = { [weak self] data in
                guard let self = self else { return }
                self.additionsArray[indexPath.row].additiveCategory = data
            }

            cell.deleteTapped = { [weak self] in
                guard let self = self else { return }
                self.additionsArray.remove(at: indexPath.row)
                self.additivesTableView.reloadData()
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

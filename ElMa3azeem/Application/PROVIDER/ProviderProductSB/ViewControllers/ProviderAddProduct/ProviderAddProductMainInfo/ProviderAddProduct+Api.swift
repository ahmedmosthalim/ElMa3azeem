//
//  ProviderAddProduct+Api.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 29/11/2022.
//

import Foundation

extension ProviderAddProductVC {
    func getMenu() {
        showLoader()
        ProviderProductRouter.getStoreMenu.send(GeneralModel<[MenuModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getMenu()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    switch self.screenReasone {
                    case .addNew:
                        self.menuTf.setupData(data: response.data ?? [])
                    case .edit:
                        self.menuTf.setupData(data: response.data ?? [])
                        self.menuTf.selectedPickerData = response.data?.first(where: { $0.id == self.productData?.storeMenuCategoryID })
                        self.menuTf.text = self.menuTf.selectedPickerData?.pickerTitle
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func getAdditives() {
        showLoader()
        ProviderProductRouter.getStoreAddition.send(GeneralModel<[AdditionModel]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getAdditives()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.additionData = response.data ?? []
                    self.setupAdditivesToEdit(product: self.productData)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func addProduct(nameAr: String, nameEn: String, price: String, haveDiscount: Bool, discountPrice: String, from: String, to: String, productType: String, inStockType: String, inStockQty: String, storeMenuId: Int, descAr: String, descEn: String, addition: String, imageData: Data?) {
        showLoader()
        var uploadedData = [UploadData]()
        if let imageData = imageData {
            uploadedData.append(UploadData(data: imageData, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "image"))
        }

        ProviderProductRouter.addProduct(nameAr: nameAr, nameEn: nameEn, price: price, haveDiscount: haveDiscount, discountPrice: discountPrice, from: from, to: to, productType: productType, inStockType: inStockType, inStockQty: inStockQty, storeMenuId: storeMenuId, descAr: descAr, descEn: descEn, addition: addition).send(GeneralModel<ProviderProductDetailsModel>.self , data: uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addProduct(nameAr: nameAr, nameEn: nameEn, price: price, haveDiscount: haveDiscount, discountPrice: discountPrice, from: from, to: to, productType: productType, inStockType: inStockType, inStockQty: inStockQty, storeMenuId: storeMenuId, descAr: descAr, descEn: descEn, addition: addition, imageData: imageData)
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

    func updateProduct(productID: Int, nameAr: String, nameEn: String, price: String, haveDiscount: Bool, discountPrice: String, from: String, to: String, productType: String, inStockType: String, inStockQty: String, storeMenuId: Int, descAr: String, descEn: String, addition: String, imageData: Data?) {
        showLoader()
        var uploadedData = [UploadData]()
        if let imageData = imageData {
            uploadedData.append(UploadData(data: imageData, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "image"))
        }

        ProviderProductRouter.updateProduct(productID: productID, nameAr: nameAr, nameEn: nameEn, price: price, haveDiscount: haveDiscount, discountPrice: discountPrice, from: from, to: to, productType: productType, inStockType: inStockType, inStockQty: inStockQty, storeMenuId: storeMenuId, descAr: descAr, descEn: descEn, addition: addition).send(GeneralModel<ProviderProductDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateProduct(productID: productID, nameAr: nameAr, nameEn: nameEn, price: price, haveDiscount: haveDiscount, discountPrice: discountPrice, from: from, to: to, productType: productType, inStockType: inStockType, inStockQty: inStockQty, storeMenuId: storeMenuId, descAr: descAr, descEn: descEn, addition: addition, imageData: imageData)
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

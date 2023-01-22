//
//  ProviderProductRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import Alamofire
import Foundation
import QuartzCore

enum ProviderProductRouter: URLRequestBuilder {
    case productDetails(productID: Int)
    case changeProductState(productID: Int)
    case getStoreMenu
    case getStoreAddition
    case getAppFeatures
    case deleteProduct(productID: Int)
    case addProduct(nameAr: String, nameEn: String, price: String, haveDiscount: Bool, discountPrice: String, from: String, to: String, productType: String, inStockType: String, inStockQty: String, storeMenuId: Int, descAr: String, descEn: String, addition: String)

    case updateProduct(productID: Int, nameAr: String, nameEn: String, price: String, haveDiscount: Bool, discountPrice: String, from: String, to: String, productType: String, inStockType: String, inStockQty: String, storeMenuId: Int, descAr: String, descEn: String, addition: String)
    case addProductFeature(productID: Int, productFeatures: String)

    case addProductGroup(productID: Int, productGroups: String)
    case updateProductGroup(productID: Int, productGroups: String)
    

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .productDetails:
            return .getSingleProduct
        case .changeProductState:
            return .controlProductState
        case .getStoreMenu:
            return .getStoreMenuCategories
        case .getStoreAddition:
            return .providerGetAdditions
        case .addProduct:
            return .ProviderAddProduct
        case .deleteProduct:
            return .providerDeleteProducr
        case .getAppFeatures:
            return .getAppFeatures
        case .addProductFeature:
            return .providerAddProductFeatures
        case .addProductGroup:
            return .providerAddProductGroup
        case .updateProduct:
            return .providerUpdateProduct
        case .updateProductGroup:
            return .providerUpdateProductGroup
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()

        switch self {
        case let .productDetails(productID: id):
            params["product_id"] = id

        case let .changeProductState(productID: id):
            params["product_id"] = id

        case let .addProduct(nameAr: nameAr, nameEn: nameEn, price: price, haveDiscount: haveDiscount, discountPrice: discountPrice, from: from, to: to, productType: productType, inStockType: inStockType, inStockQty: inStockQty, storeMenuId: storeMenuId, descAr: descAr, descEn: descEn, addition: addition):

            params = [
                "name_ar": nameAr,
                "name_en": nameEn,
                "price": price,
                "type": productType,
                "in_stock_type": inStockType,
                "in_stock_qty": inStockQty,
                "store_menu_category_id": storeMenuId,
                "desc_ar": descAr,
                "desc_en": descEn,
                "addition": addition,
            ]

            if addition != "" {
                params["addition"] = addition
            }

            if haveDiscount {
                params["discount_price"] = discountPrice
                params["from"] = from
                params["to"] = to
            }
            
        case let .updateProduct(productID: id, nameAr: nameAr, nameEn: nameEn, price: price, haveDiscount: haveDiscount, discountPrice: discountPrice, from: from, to: to, productType: productType, inStockType: inStockType, inStockQty: inStockQty, storeMenuId: storeMenuId, descAr: descAr, descEn: descEn, addition: addition):

            params = [
                "product_id": id,
                "name_ar": nameAr,
                "name_en": nameEn,
                "price": price,
                "type": productType,
                "in_stock_type": inStockType,
                "in_stock_qty": inStockQty,
                "store_menu_category_id": storeMenuId,
                "desc_ar": descAr,
                "desc_en": descEn,
                "addition": addition,
            ]

            if addition != "" {
                params["addition"] = addition
            }

            if haveDiscount {
            params["discount_price"] = discountPrice
            params["from"] = from
            params["to"] = to
            }

        case let .deleteProduct(productID: id):
            params = [
                "product_id": id,
            ]

        case let .addProductFeature(productID: id, productFeatures: features):
            params = [
                "product_id": id,
                "productfeatures": features,
            ]

        case let .addProductGroup(productID: id, productGroups: groups):
            params = [
                "product_id": id,
                "productfeatures_ids": groups,
            ]

        case let .updateProductGroup(productID: id, productGroups: groups):
            params = [
                "product_id": id,
                "productfeatures_ids": groups,
            ]

        default:
            params = [:]
        }

        print(params)
        return params
    }

    // MARK: - headers

    internal var headers: HTTPHeaders {
        var header = HTTPHeaders()

        let Lang = Language.apiLanguage()
        let token = defult.shared.getData(forKey: .token) ?? ""

        switch self {
        default:
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"
        }
        print(header)
        return header
    }

    // MARK: - Method

    internal var method: HTTPMethod {
        switch self {
        case .productDetails, .getStoreMenu, .getStoreAddition, .getAppFeatures:
            return .get
        case .deleteProduct:
            return .delete
        case .updateProductGroup:
            return .put
        default:
            return .post
        }
    }

    internal var requestURL: URL {
        let url = mainURL.appendingPathComponent(path.rawValue)
        print(url)
        return url
    }

    // MARK: - Encoding

//    internal var encoding: ParameterEncoding {
//        switch self {
//        case .home, .myOrders, .logOut, .notifyCount:
//            return URLEncoding.default
//        default:
//            return JSONEncoding.default
//
//        }
//    }
}

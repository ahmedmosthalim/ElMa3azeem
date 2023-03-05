//
//  ProviderMoreRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 04/11/2022.
//

import Alamofire
import CoreLocation
import Foundation

enum ProviderMoreRouter: URLRequestBuilder {
    case getCategories
    case getProviderProfile
    case updateStoreProfile(nameAr: String, nameEn: String, category: String, location: CLLocationCoordinate2D, address: String, baankAccountNumber: String, ibanNumber: String, bankName: String, commirtialID: String, days: String,isDelivery:Bool)

    // branckes
    case getBranches(page: Int)
    case getSingleBranch(branchId: Int)
    case deleteBranch(branchId: Int)
    case addNewBranch(location: CLLocationCoordinate2D, address: String, countryKey: String, phone: String, email: String, haveMasterBranchTimes: Bool, workTimes: String)
    case updateBranch(branchID: Int, location: CLLocationCoordinate2D, address: String, countryKey: String, phone: String, email: String, haveMasterBranchTimes: Bool, workTimes: String)

    // menu
    case addMenu(nameAr: String, nameEn: String)
    case updateMenu(menuID: Int, nameAr: String, nameEn: String)
    case deleteMenu(menuID: Int)

    case addAddition(nameAr: String, nameEn: String)
    case updateAddition(additionID: Int, nameAr: String, nameEn: String)
    case deleteAddition(additionID: Int)

    case getStoreFinance
    case getStoreReviews


    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .getCategories:
            return .categories
        case .getProviderProfile:
            return .profileStoreShow
        case .updateStoreProfile:
            return .profileUpdateStore
        case .getBranches:
            return .providerGetBranches
        case .addNewBranch:
            return .providerAddBranches
        case .deleteBranch:
            return .providerDeleteBranch
        case .getSingleBranch:
            return .providerSimgleBranch
        case .updateBranch:
            return .providerUpdateBranch
        case .addMenu:
            return .providerAddMenuSection
        case .updateMenu:
            return .providerUpdateMenuSection
        case .deleteMenu:
            return .providerDeleteMenuSetion
        case .addAddition:
            return .providerAddAdditionSection
        case .updateAddition:
            return .providerUpdateAdditionSection
        case .deleteAddition:
            return .providerDeleteAdditionSetion
        case .getStoreFinance:
            return .providerGetStoreFinance
        case .getStoreReviews:
            return .providerGetStoreReviews

        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()

        switch self {
        case let .updateStoreProfile(nameAr: nameAr, nameEn: nameEn, category: category, location: location, address: address, baankAccountNumber: baankAccountNumber, ibanNumber: ibanNumber, bankName: bankName, commirtialID: commirtialID, days: days,isDelivery:isDelivery):
            params = [
                "name_ar": nameAr,
                "name_en": nameEn,
                "category": category,
                "lat": location.latitude,
                "long": location.longitude,
                "address": address,
                "commercial_id": commirtialID,
                "bank_name": bankName,
                "iban_number": ibanNumber,
                "bank_number": baankAccountNumber,
                "days": days,
                "is_delivery" : isDelivery,
            ]

        case let .getBranches(page: page):
            params = [
                "page": page,
            ]

        case let .addNewBranch(location: location, address: address, countryKey: countryKey, phone: phone, email: email, haveMasterBranchTimes: haveMasterBranchTimes, workTimes: workTimes):
            params = [
                "address": address,
                "lat": String(location.latitude),
                "long": String(location.longitude),
                "country_key": countryKey,
                "phone": phone,
                "email": email,
                "days": workTimes,
            ]

            if haveMasterBranchTimes == true {
                params["store_days"] = "on"
            }

        case let .updateBranch(branchID: id, location: location, address: address, countryKey: countryKey, phone: phone, email: email, haveMasterBranchTimes: haveMasterBranchTimes, workTimes: workTimes):
            params = [
                "branch_id": id,
                "address": address,
                "lat": String(location.latitude),
                "long": String(location.longitude),
                "country_key": countryKey,
                "phone": phone,
                "email": email,
                "days": workTimes,
            ]

            if haveMasterBranchTimes == true {
                params["store_days"] = "on"
            }

        case let .deleteBranch(branchId: id):
            params = [
                "branch_id": id,
            ]

        case let .getSingleBranch(branchId: id):
            params = [
                "branch_id": id,
            ]

        case let .addMenu(nameAr: nameAr, nameEn: nameEn):
            params = [
                "name_ar": nameAr,
                "name_en": nameEn,
            ]

        case let .updateMenu(menuID: id, nameAr: nameAr, nameEn: nameEn):
            params = [
                "menu_id": id,
                "name_ar": nameAr,
                "name_en": nameEn,
            ]

        case let .deleteMenu(menuID: id):
            params = [
                "menu_id": id,
            ]

        case let .addAddition(nameAr: nameAr, nameEn: nameEn):
            params = [
                "name_ar": nameAr,
                "name_en": nameEn,
            ]

        case let .updateAddition(additionID: id, nameAr: nameAr, nameEn: nameEn):
            params = [
                "additive_id": id,
                "name_ar": nameAr,
                "name_en": nameEn,
            ]

        case let .deleteAddition(additionID: id):
            params = [
                "additive_id": id,
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
        case .getCategories, .getProviderProfile, .getBranches, .getSingleBranch, .getStoreFinance, .getStoreReviews:
            return .get

        case .deleteBranch, .deleteMenu, .deleteAddition:
            return .delete

        case .updateAddition:
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

//
//    internal var encoding: ParameterEncoding {
//        switch self {
//        case .deleteAddition:
//            return JSONEncoding.default
//        default:
//            return URLEncoding.default
//
//        }
//    }
}

//
//  ProviderHomeNetworkRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 20/11/2022.
//

import Alamofire
import Foundation

enum ProviderHomeNetworkRouter: URLRequestBuilder {
    case home(lat : String ,long : String)
    case myOrders(status: String, page: String)
    case myProduct(page: Int , searchText: String)
    case notifyCount
    case logOut

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .home:
            return .home
        case .myOrders:
            return .storeOrders
        case .myProduct:
            return .providerMyProduct
        case .notifyCount:
            return .notifyCount
        case .logOut:
            return .logOut
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()

        switch self {
            
        case let .home(lat: lat, long: long):
            params = [
             "lat" : lat,
             "long" : long
            ]
            
        case let .myOrders(status: status, page: page):

            params = [
                "status": status,
                "page": page,
            ]

        case let .myProduct(page: page , searchText: searchText):
            params = [
                "page": page,
            ]
            
            if searchText != "" {
                params["search"] = searchText
            }

        case .logOut:
            params = [
                "device_id": AppDelegate.FCMToken,
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
        case .home, .myOrders, .notifyCount ,.myProduct:
            return .get
        default:
            return .post
        }
    }

    internal var requestURL: URL {
        let url = mainURL.appendingPathComponent(path.rawValue)

        switch self {
        case .home, .myOrders, .logOut, .notifyCount ,.myProduct:
            break
        }

        print(url)
        return url
    }

    // MARK: - Encoding

    internal var encoding: ParameterEncoding {
        switch self {
//        case .home, .myOrders, .logOut, .notifyCount:
//            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}


protocol FeaturePrtocol {
    var features : [FeatureItem] {get}
}

protocol FeatureItem : Codable{
    var featureTitle : String {get}
    var featureSubTitle :String {get}
    var featurePrice : String {get}
}

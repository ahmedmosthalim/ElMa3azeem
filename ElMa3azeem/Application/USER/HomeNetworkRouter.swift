//
//  HomeNetworkRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import Alamofire
import Foundation

enum HomeNetworkRouter: URLRequestBuilder {
    // Home
    case home(lat: String, long: String)
    case notifyCount
    case logOut
    case subCategory(id: String)

    // Order
    case myOrders(status: String, type: String, page: String)
    case getOffers(page: Int)

    // Delegate
    case delegateNearOrder(type: String, lat: String, long: String, page: String)
    case delegateDeliveryOrders(status: String, type: String, page: String)

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .home:
            return .home
        case .myOrders:
            return .myOrder
        case .logOut:
            return .logOut
        case .delegateNearOrder:
            return .delegateNearWaitingOrders
        case .delegateDeliveryOrders:
            return .delegateOrders
        case .notifyCount:
            return .notifyCount
        case .getOffers:
            return .offerStores
        case .subCategory:
            return .subCategory
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()

        switch self {
        case let .home(lat: lat, long: long):
            params = [
                "lat": lat,
                "long": long,
            ]

        case let .myOrders(status: status, type: type, page: page):
            if type == "" {
                params = [
                    "status": status,
                ]
            } else {
                params = [
                    "status": status,
                    "type": type,
                ]
            }

            params["page"] = page
        case .logOut:
            params = [
                "device_id": AppDelegate.FCMToken,
            ]

        case let .delegateNearOrder(type: type, lat: lat, long: long, page: page):
            if type == "" {
                params = [
                    "lat": lat,
                    "long": long,
                ]
            } else {
                params = [
                    "type": type,
                    "lat": lat,
                    "long": long,
                ]
            }

            params["page"] = page

        case let .delegateDeliveryOrders(status: status, type: type, page: page):
            if type == "" {
                params = [
                    "status": status,
                ]
            } else {
                params = [
                    "status": status,
                    "type": type,
                ]
            }

            params["page"] = page

        case let .getOffers(page: page):
            params["page"] = page
            
        case let .subCategory(id):
            params["category_id"] = id

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
        case .home, .myOrders, .delegateNearOrder, .delegateDeliveryOrders, .notifyCount, .getOffers ,.subCategory:
            return .get
        default:
            return .post
        }
    }

    internal var requestURL: URL {
        let url = mainURL.appendingPathComponent(path.rawValue)

        switch self {
        case .home, .myOrders, .logOut, .delegateNearOrder, .delegateDeliveryOrders, .notifyCount, .getOffers ,.subCategory:
            break
        }

        print(url)
        return url
    }

    // MARK: - Encoding

    internal var encoding: ParameterEncoding {
        switch self {
//        case .home ,.myOrders,.logOut,.delegateNearOrder,.delegateDeliveryOrders ,.notifyCount ,.getOffers:

        default:
            return URLEncoding.default
//            return JSONEncoding.default
        }
    }
}

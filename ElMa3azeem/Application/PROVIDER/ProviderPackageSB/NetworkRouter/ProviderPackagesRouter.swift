//
//  ProviderPackagesRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 22/11/2022.
//

import Alamofire
import Foundation

enum ProviderPackagesRouter: URLRequestBuilder {
    case providerPackages
    case getPaymentWay
    case payPackageWithWallet(planID: Int)
    case subscribePackage(planID: Int, paymentType: String)
    case removeSubscription(planID : Int)

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .providerPackages:
            return .getPlans
        case .getPaymentWay:
            return .getPlanPaymentMethods
        case .subscribePackage:
            return .subscribePlan
        case .payPackageWithWallet:
            return .payPlanWithWallet
        case .removeSubscription:
            return .removeSubscription
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()

        switch self {
        case let .subscribePackage(planID: planID, paymentType: paymentType):
            params = [
                "plan_id": planID,
                "payment_type": paymentType,
            ]
            
        case let .payPackageWithWallet(planID: planID):
            params = [
                "plan_id" : planID
            ]
        case let .removeSubscription(planID: id):
            params = [
                "plan_id" : id
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
        case .providerPackages, .getPaymentWay:
            return .get
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

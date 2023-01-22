//
//  ProviderOrderRourder.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 23/11/2022.
//

import Alamofire
import Foundation

enum ProviderOrderRourder: URLRequestBuilder {
//    orderDetails
    case orderDetails(orderID: Int)
    case cancelReasones
    case rateStore(orderID: String, rate: String, storeID: String, comment: String)
    case rateUser(orderID: String, rate: String, secondUserId: String, comment: String)
    case changePaymentMethod(orderID: String, paymentType: String)
    case providerAcceptOrder(orderID: Int)
    case userRejectDeliveryOffer(deliveryOfferID: String)
    case cancelOrder(orderID: String, reason: String)
    case walletPayment(orderID: String)
    case complainteReasones
    case crateComplainte(orderID: String, subject: String, text: String)
    case orderIsReady(orderID: Int)
    case deliverOrder(orderID: Int)

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .orderDetails:
            return .storeSingleOrder
        case .cancelReasones:
            return .cancelReasones
        case .rateStore:
            return .reviewStore
        case .rateUser:
            return .reviewUser
        case .changePaymentMethod:
            return .changePaymenMethod
        case .providerAcceptOrder:
            return .storeAcceptOrder
        case .userRejectDeliveryOffer:
            return .userRejectDeliveryOffer
        case .cancelOrder:
            return .storeRejectOrder
        case .walletPayment:
            return .payOrderWithWallet
        case .crateComplainte:
            return .createTicket
        case .complainteReasones:
            return .reportReasons
        case .orderIsReady:
            return .storePrepareOrder
        case .deliverOrder:
            return .storeDeliverOrder
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()
        switch self {
        case let .orderDetails(orderID: id):
            params = [
                "order_id": id,
            ]

        case let .rateStore(orderID: orderID, rate: rate, storeID: storeID, comment: comment):
            params = [
                "order_id": orderID,
                "rate": rate,
                "store_id": storeID,
            ]

            if comment != "If there are comments, add here".localized && comment != "" {
                params["comment"] = comment
            }

        case let .rateUser(orderID: orderID, rate: rate, secondUserId: secondUserId, comment: comment):
            params = [
                "order_id": orderID,
                "rate": rate,
                "seconduser_id": secondUserId,
            ]

            if comment != "If there are comments, add here".localized && comment != "" {
                params["comment"] = comment
            }

        case let .changePaymentMethod(orderID: orderID, paymentType: paymentType):
            params = [
                "order_id": orderID,
                "payment_type": paymentType,
            ]

        case let .providerAcceptOrder(orderID: id):
            params = [
                "order_id": id,
            ]

        case let .userRejectDeliveryOffer(deliveryOfferID: id):
            params = [
                "delivery_offer_id": id,
            ]

        case let .cancelOrder(orderID: id, reason: reason):
            params = [
                "order_id": id,
                "reason": reason,
            ]

        case let .walletPayment(orderID: id):
            params = [
                "order_id": id,
            ]

        case let .crateComplainte(orderID: id, subject: subject, text: text):
            params = [
                "order_id": id,
                "subject": subject,
                "text": text,
            ]

        case let .orderIsReady(orderID: id):
            params = [
                "order_id": id,
            ]

        case let .deliverOrder(orderID: id):
            params = [
                "order_id": id,
            ]

        default:
            return nil
        }

//        params["count_notifications"] = ""

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

        return header
    }

    // MARK: - Method

    internal var method: HTTPMethod {
        switch self {
        case .orderDetails, .cancelReasones, .complainteReasones:
            return .get
        default:
            return .post
        }
    }

    // MARK: - URL

    var requestURL: URL {
        let url = mainURL.appendingPathComponent(path.rawValue)
        switch self {
        default:
            break
        }

        print(url)
        return url
    }

    // MARK: - Encoding

    internal var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
}

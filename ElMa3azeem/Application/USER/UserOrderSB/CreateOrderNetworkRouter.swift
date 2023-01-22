//
//  OrderNetworkRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 16/11/2022.
//

import Alamofire
import Foundation

enum CreateOrderNetworkRouter: URLRequestBuilder {
    
    case getSubCategories (id:String)
    case storeDetails(id: String, lat: String, long: String)
    case storeReviews(id: String)
    case storeBranches(id: String, lat: String, long: String)
    case storeProduct(productID: String)
    case selectGroup(productID: String, properities: String)
    case paymentMethod
    case orderPrices(storeId: Int, receiveLat: String, receiveLong: String, deliverLat: String, deliverLong: String, coupon: String, price: Double)

    case createOrder(storeID: String, storeName: String, storeIcon: String, groups: String, needsDelivery: Bool, deliverTime: String, receiveLat: String, receiveLong: String, receiveAddres: String, deliverLat: String, deliverLong: String, deliverAddres: String, coupon: String, type: String, paymentType: String, description: String , deliveryDate : String)

    case createOrderNoContruct(storeID: String, storeName: String, storeIcon: String, deliverTime: String, receiveLat: String, receiveLong: String, receiveAddres: String, deliverLat: String, deliverLong: String, deliverAddres: String, coupon: String, type: String, paymentType: String, description: String)

    case createParcelDelivery(deliverTime: String, receiveLat: String, receiveLong: String, receiveAddres: String, deliverLat: String, deliverLong: String, deliverAddres: String, coupon: String, type: String, paymentType: String, description: String)

    case createSpecialRequest(deliverTime: String, deliverLat: String, deliverLong: String, deliverAddres: String, type: String, paymentType: String, description: String)

    case nearstores(categoty: String, lat: String, long: String, page: String, searchText: String, rate: String)
    case nearStoresOneCategory(lat: String, long: String, page: String, categoryName : String)
    case nearStoresSubCategory(lat: String, long: String, page: String,subCategoryId : Int)

//    address book
    case addressBook
    case addAddress(title: String, lat: String, long: String, address: String)
    case deleteAddress(addressID: String)
    case editAddress(addressID: String, title: String, lat: String, long: String, address: String)

//    orderDetails
    case orderDetails(orderID: String)
    case cancelReasones
    case rateStore(orderID: String, rate: String, storeID: String, comment: String)
    case rateUser(orderID: String, rate: String, secondUserId: String, comment: String)
    case changePaymentMethod(orderID: String, paymentType: String)
    case userAcceptDeliveryOffer(deliveryOfferID: String)
    case userRejectDeliveryOffer(deliveryOfferID: String)
    case cancelOrder(orderID: String, reason: String)
    case walletPayment(orderID: String)
    case complainteReasones
    case crateComplainte(orderID: String, subject: String, text: String)
    case favourite(productID : Int)

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .storeDetails:
            return .storeDetails
        case .storeReviews:
            return .storeReviews
        case .storeBranches:
            return .storeBranches
        case .storeProduct:
            return .storeProduct
        case .selectGroup:
            return .selectGroup
        case .paymentMethod:
            return .paymentMethods
        case .addressBook:
            return .addressBook
        case .addAddress:
            return .addAddress
        case .deleteAddress:
            return .deleteAddress
        case .editAddress:
            return .editAddress
        case .orderPrices:
            return .orderEnquiry
        case .createOrder:
            return .createOrder
        case .nearstores , .nearStoresSubCategory , .nearStoresOneCategory:
            return .nearstores
        case .createOrderNoContruct:
            return .createOrder
        case .createParcelDelivery:
            return .createOrder
        case .createSpecialRequest:
            return .createOrder
        case .orderDetails:
            return .userSingleOrder
        case .cancelReasones:
            return .cancelReasones
        case .rateStore:
            return .reviewStore
        case .rateUser:
            return .reviewUser
        case .changePaymentMethod:
            return .changePaymenMethod
        case .userAcceptDeliveryOffer:
            return .userAcceptDeliveryOffer
        case .userRejectDeliveryOffer:
            return .userRejectDeliveryOffer
        case .cancelOrder:
            return .cancelOrder
        case .walletPayment:
            return .payOrderWithWallet
        case .crateComplainte:
            return .createTicket
        case .complainteReasones:
            return .reportReasons
        case .favourite:
            return .favourite
        case .getSubCategories :
            return .subCategory
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()
        switch self {
        case let .storeDetails(id: id, lat: lat, long: long):
            params = [
                "store_id": id,
                "lat": lat,
                "long": long,
            ]

        case let .storeReviews(id: id):
            params = [
                "store_id": id,
            ]

        case let .storeBranches(id: id, lat: lat, long: long):
            params = [
                "store_id": id,
                "lat": lat,
                "long": long,
            ]

        case let .storeProduct(productID: productID):
            params = [
                "product_id": productID,
            ]
        case let .selectGroup(productID: productID, properities: properities):
            params = [
                "product_id": productID,
                "properities": properities,
            ]

        case let .addAddress(title: titile, lat: lat, long: long, address: address):
            params = [
                "title": titile,
                "lat": lat,
                "long": long,
                "address": address,
            ]

        case let .deleteAddress(addressID: id):
            params = [
                "address_id": id,
            ]

        case let .editAddress(addressID: id, title: titile, lat: lat, long: long, address: address):
            params = [
                "address_id": id,
                "title": titile,
                "lat": lat,
                "long": long,
                "address": address,
            ]

        case let .orderPrices(storeId: storeId, receiveLat: receiveLat, receiveLong: receiveLong, deliverLat: deliverLat, deliverLong: deliverLong, coupon: coupon, price: price):

            params = [
                "receive_lat": receiveLat,
                "receive_long": receiveLong,
                "deliver_lat": deliverLat,
                "deliver_long": deliverLong,
                "price": price,
            ]

            if storeId != 0 {
                params["store_id"] = storeId
            }

            if coupon != "" {
                params["coupon"] = coupon
            }

        case let .createOrder(storeID: storeID, storeName: storeName, storeIcon: storeIcon, groups: groups, needsDelivery: needsDelivery, deliverTime: deliverTime, receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentType, description: description , deliveryDate:deliveryDate):
            params = [
                "store_id": storeID,
                "store_name": storeName,
                "store_icon": storeIcon,
                "groups": groups,
                "receive_lat": receiveLat,
                "receive_long": receiveLong,
                "receive_address": receiveAddres,
                "payment_type": paymentType,
                "type": type,
                "needs_delivery": "\(needsDelivery)",
                "delivery_date" : deliveryDate
            ]

            if description != "" {
                params["description"] = description
            }

            if coupon != "" {
                params["coupon"] = coupon
            }

            if needsDelivery == true {
                params["deliver_lat"] = deliverLat
                params["deliver_long"] = deliverLong
                params["deliver_address"] = deliverAddres
                params["deliver_time"] = deliverTime
            }

        case let .createOrderNoContruct(storeID: storeID, storeName: storeName, storeIcon: storeIcon, deliverTime: deliverTime, receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentType, description: description):
            params = [
                "store_id": storeID,
                "store_name": storeName,
                "store_icon": storeIcon,
                "receive_lat": receiveLat,
                "receive_long": receiveLong,
                "receive_address": receiveAddres,
                "payment_type": paymentType,
                "type": type,
                "deliver_lat": deliverLat,
                "deliver_long": deliverLong,
                "deliver_address": deliverAddres,
                "deliver_time": deliverTime,
            ]

            if description != "" {
                params["description"] = description
            }

            if coupon != "" {
                params["coupon"] = coupon
            }

        case let .createParcelDelivery(deliverTime: deliverTime, receiveLat: receiveLat, receiveLong: receiveLong, receiveAddres: receiveAddres, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, coupon: coupon, type: type, paymentType: paymentType, description: description):
            params = [
                "receive_lat": receiveLat,
                "receive_long": receiveLong,
                "receive_address": receiveAddres,
                "payment_type": paymentType,
                "type": type,
                "deliver_lat": deliverLat,
                "deliver_long": deliverLong,
                "deliver_address": deliverAddres,
                "deliver_time": deliverTime,
                "needs_delivery": "true",
            ]

            if description != "" {
                params["description"] = description
            }

            if coupon != "" {
                params["coupon"] = coupon
            }

        case let .createSpecialRequest(deliverTime: deliverTime, deliverLat: deliverLat, deliverLong: deliverLong, deliverAddres: deliverAddres, type: type, paymentType: paymentType, description: description):
            params = [
                "deliver_time": deliverTime,
                "payment_type": paymentType,
                "type": type,
                "deliver_lat": deliverLat,
                "deliver_long": deliverLong,
                "deliver_address": deliverAddres,
                "needs_delivery": "true",
            ]

            if description != "" {
                params["description"] = description
            }

        case let .nearStoresSubCategory(lat: lat, long: long , page: page , subCategoryId: id) :
            params = [
                "lat": lat,
                "long": long,
                "page": page,
                "subcategory_id": id

            ]
        case let .nearstores(categoty: categoty, lat: lat, long: long, page: page, searchText: text , rate : rate):
            params = [
                "lat": lat,
                "long": long,
                "subcategory_id": categoty,
                "page": page
            ]
            if rate != "" {
                params["rate"] = rate
            }

            if text != "" {
                params["search"] = text
            }
        case let .nearStoresOneCategory(lat: lat, long: long, page: page , categoryName: categoryName):
            params = [
                "lat": lat,
                "long": long,
                "category": categoryName,
                "page": page
            ]
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

        case let .userAcceptDeliveryOffer(deliveryOfferID: id):
            params = [
                "delivery_offer_id": id,
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
            
        case let .favourite(productID: id):
            params = [
                "product_id" : id
            ]
        case let .getSubCategories(id: id) :
            params = [
                "category_id" : id 
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
        case .storeDetails, .storeReviews, .storeBranches, .storeProduct, .selectGroup, .paymentMethod, .addressBook, .nearstores, .orderDetails, .cancelReasones, .complainteReasones , .nearStoresSubCategory , .getSubCategories , .nearStoresOneCategory :
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
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

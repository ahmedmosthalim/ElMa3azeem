//
//  DelegateNetworkRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import Foundation
import Alamofire
 

enum DelegateNetworkRouter: URLRequestBuilder {
    
    case delegateSinglOrder(orderID:String)
    case acceptOrder(orderID:String)
    case delegateIntransitOrder(orderID:String , deliveryStatus:String)
    case delegateFinishOrder(orderID:String)
    case delegateMakeOffer(orderID:String , deliveryPrice:String)
    case delegateCreateOrderInvoce(orderID:String , price:String)
    case withdrawReasones
    case withdrawFromOrder(orderID:String , reason:String)
    
    // MARK: - Paths
    internal var path: ServiceURL {
        switch self {
        case.delegateSinglOrder:
            return .delegateSingleOrder
        case .acceptOrder:
            return .delegateAcceptOrder
        case .delegateIntransitOrder:
            return .delegateIntransitOrder
        case .delegateFinishOrder:
            return .delegateFinishOrder
        case .delegateMakeOffer:
            return .delegatemakeDeliveryOffer
        case .delegateCreateOrderInvoce:
            return .delegateCreateOrderInvoice
        case .withdrawFromOrder:
            return .delegateWithdrawOrder
        case .withdrawReasones:
            return .withdrawReasons
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters()
        switch self {
        case .delegateSinglOrder(orderID: let id):
            params = [
                "order_id" : id,
            ]
            
        case .acceptOrder(orderID: let id):
            params = [
                "order_id" : id,
            ]
            
        case .delegateIntransitOrder(orderID: let id , deliveryStatus: let state):
            params = [
                "order_id" : id,
                "delivery_status" : state
            ]
            
        case .delegateFinishOrder(orderID: let id):
            params = [
                "order_id" : id,
            ]
            
        case .delegateMakeOffer(orderID: let id, deliveryPrice: let price):
            params = [
                "order_id" : id,
                "delivery_price" : price
            ]
            
        case .delegateCreateOrderInvoce(orderID: let id , price: let price):
            params = [
                "order_id" : id,
                "price" : price
            ]
            
        case .withdrawFromOrder(orderID: let id , reason : let reason):
            params = [
                "order_id" : id,
                "reason" : reason
            ]
            
        default :
            return nil
        }
        
        print(params)
        
        return params
    }
    
    // MARK: - headers
    internal var headers: HTTPHeaders{
        var header = HTTPHeaders()
        
        var Lang = Language.apiLanguage()
        let token = defult.shared.getData(forKey: .token) ?? ""
        
        switch self {
            
        default :
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"
            
        }
        
        return header
    }
    
    // MARK: - Method
    internal var method: HTTPMethod {
        switch self {
        case .delegateSinglOrder ,.withdrawReasones:
            return .get
        default:
            return .post
        }
    }
    
    // MARK: - URL
    var requestURL : URL {
        let url = mainURL.appendingPathComponent(path.rawValue)
        switch self {
        default :
            break
        }
        
        print(url)
        return url
    }
    
    // MARK: - Encoding
    internal var encoding: ParameterEncoding {
        switch self {
        case .delegateSinglOrder ,.acceptOrder ,.delegateIntransitOrder ,.delegateFinishOrder ,.delegateMakeOffer ,.delegateCreateOrderInvoce ,.withdrawFromOrder ,.withdrawReasones:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}


//
//  DelegateNearOrderModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import Foundation
// MARK: - DelegateNearOrderModel
struct DelegateNearOrderModel: Codable , CodableInit{
    var orders: [DelegateOrder]
    let pagination : Pagination?
}

// MARK: - Order
struct DelegateOrder: Codable {
    var id: Int
    var createdAt, status: String
    var image: String
    var name, distanceToReceiveAddress, distanceToDeliverAddress: String
    var type : String
    var userName : String
    
    var orderType: OrderType {
        switch self.type {
        case OrderType.specialStoreWithDelivery.rawValue:
            return .specialStoreWithDelivery
        case OrderType.googleStore.rawValue:
            return .googleStore
        case OrderType.parcelDelivery.rawValue:
            return .parcelDelivery
        case OrderType.specialPackage.rawValue:
            return .specialPackage
        default:
            return .defult
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case createdAt = "created_at"
        case status, image, name , type
        case distanceToReceiveAddress = "distance_to_receive_address"
        case distanceToDeliverAddress = "distance_to_deliver_address"
    }
}

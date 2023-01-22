//
//  OrderModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2611/2022.
//

import Foundation

// MARK: - OrderModel
struct OrderModel: Codable {
    var orders: [Order]
    let pagination : Pagination?
}

// MARK: - Order
struct Order: Codable {
    var id: Int
    var createdAt, status: String
    var image , type: String 
    var name, distanceToReceiveAddress, distanceToDeliverAddress: String
    
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
        case createdAt = "created_at"
        case status, image, name , type
        case distanceToReceiveAddress = "distance_to_receive_address"
        case distanceToDeliverAddress = "distance_to_deliver_address"
    }
}

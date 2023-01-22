//
//  OrderPriceModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2111/2022.
//

import Foundation

// MARK: - OrderPriceModel
struct OrderPriceModel: Codable {
    var deliveryPrice, appPercentage, addedValue, discount: String
    var totalPrice: String
    var hasCoupon : Bool?

    enum CodingKeys: String, CodingKey {
        case deliveryPrice = "delivery_price"
        case appPercentage = "app_percentage"
        case addedValue = "added_value"
        case discount
        case totalPrice = "total_price"
        case hasCoupon = "has_coupon"
    }
}


// MARK: - CreateOrderModel
struct CreateOrderModel: Codable , CodableInit{
    var userStatus, msg, key: String
    var code: Int
    var data: CreateOrderData?

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

// MARK: - DataClass
struct CreateOrderData: Codable {
    var orderID: Int

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
    }
}

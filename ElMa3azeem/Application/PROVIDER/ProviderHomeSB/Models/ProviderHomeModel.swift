//
//  ProviderHomeModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 20/11/2022.
//

import Foundation

// MARK: - DataClass
struct ProviderHomeModel: Codable {
    let statistics: Statistics
    let isSubscribe : Bool?
}

// MARK: - Statistics
struct Statistics: Codable {
    let newOrders, activeOrders, finishOrders, products: Int
    
    enum CodingKeys: String, CodingKey {
        case newOrders = "new_orders"
        case activeOrders = "active_orders"
        case finishOrders = "finish_orders"
        case products
    }
}

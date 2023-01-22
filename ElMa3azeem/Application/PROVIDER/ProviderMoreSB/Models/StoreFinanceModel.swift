//
//  StoreFinanceModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import Foundation

// MARK: - Empty

struct StoreFinanceModel: Codable {
    let id, price,orderID: Int
    let appPercentage, addedValue, totalPrice, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, price
        case orderID = "order_id"
        case appPercentage = "app_percentage"
        case addedValue = "added_value"
        case totalPrice = "total_price"
        case createdAt = "created_at"
    }
}

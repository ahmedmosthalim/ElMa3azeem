//
//  ProviderProductGroupModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Foundation

struct AddProductGroupModel: Codable {
    var id : Int?
    var features: [Feature]
    var price, qty: String
    var discountPrice: String
    var from: Date
    var to: Date

    enum CodingKeys: String, CodingKey {
        case id
        case features = "properties"
        case price
        case qty
        case discountPrice
        case from
        case to
    }
}

struct AddProductGroupAPIModel: Codable {
    var id : Int?
    var properties: [Int]
    var price, qty: String
    var discountPrice: String?
    var from: String?
    var to: String?

    enum CodingKeys: String, CodingKey {
        case properties
        case price
        case qty
        case discountPrice = "discount_price"
        case from
        case to
        case id
    }
}

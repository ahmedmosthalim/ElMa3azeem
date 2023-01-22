//
//  ProviderMyProduct.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 26/11/2022.
//

import Foundation

// MARK: - ProviderProductModel

struct ProviderProductModel: Codable {
    let products: [ProviderProductData]
    let pagination: Pagination
}

struct ProviderProductData: Codable {
    let id: Int
    let image, name, desc, displayPrice: String

    enum CodingKeys: String, CodingKey {
        case id, image, name, desc
        case displayPrice = "display_price"
    }
}

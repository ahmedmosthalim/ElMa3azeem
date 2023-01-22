//
//  ProviderPackagesModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 22/11/2022.
//

import Foundation

// MARK: - ProviderPackagesModel

struct ProviderPackagesModel: Codable {
    let description, expireDate: String
    let id: Int
    let logo: String
    let name, price: String
    let subscribed: Bool
    var isSelected: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case description
        case expireDate = "expire_date"
        case id, logo, name, price, subscribed
    }
}

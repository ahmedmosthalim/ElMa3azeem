//
//  PaymentModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1911/2022.
//

import Foundation

struct PaymentModel: Codable , CodableInit{
    let paymentMethods: [PaymentMethod]

    enum CodingKeys: String, CodingKey {
        case paymentMethods = "payment_methods"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let id: Int
    let key, name, desc: String
    let image: String
    var isSelected : Bool? = false
}


//
//  AddressModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2011/2022.
//

import Foundation

// MARK: - AddressModel
struct AddressModel: Codable ,CodableInit {
    var addresses: [Address]
}

// MARK: - Address
struct Address: Codable {
    var id: Int
    var title, lat, long, address: String
}

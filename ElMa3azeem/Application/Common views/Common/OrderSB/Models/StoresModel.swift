//
//  StoresModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2111/2022.
//

import Foundation

// MARK: - StoreModel
struct StoreModel: Codable , CodableInit {
    let stores: [Store]
    let pagination : Pagination?
}

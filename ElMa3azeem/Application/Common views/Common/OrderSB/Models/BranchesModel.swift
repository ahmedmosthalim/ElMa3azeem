//
//  BranchesModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import Foundation

struct BranchesModel: Codable, CodableInit {
    let branches: [Branch]
    let pagination : Pagination?
}

// MARK: - Branch

struct Branch: Codable {
    var id: Int
    var name: String
    var icon: String
    var address, lat, long, rate: String
    var categoryName, distance: String
    var isOpen, available: Bool
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case isOpen = "is_open"
        case name, icon, address, lat, long, rate
        case categoryName = "category_name"
        case available, distance
    }
}

//
//  CancelReasonsModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 04/01/2022.
//

import Foundation

// MARK: - CancelReasonsModel
struct ReasonsModel: Codable , CodableInit {
    var reasons: [ReasonsData]
}

// MARK: - CancelReasonsModel
struct ReasonsData: Codable {
    var id: Int
    var reason: String
    var isSelected : Bool? = false
}

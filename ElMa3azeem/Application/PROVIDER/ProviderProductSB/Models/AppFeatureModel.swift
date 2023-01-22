//
//  AppFeatureModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import Foundation

// MARK: - Datum

struct AppFeatureModel: GeneralPickerModel, Codable {
    var id: Int
    var name: String?
    var properties: [Properity]?
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case properties = "properties"
    }

    var pickerId: Int {
        return id
    }

    var pickerTitle: String {
        return name ?? ""
    }

    var pickerKey: String {
        return ""
    }
}


struct FeatureApiModel: Codable {
    var featureId: Int
    var properties: [PropertiesApiModel]
    
    enum CodingKeys: String, CodingKey {
        case featureId = "feature_id"
        case properties = "properties"
    }
}

struct PropertiesApiModel: Codable {
    var id: Int
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}

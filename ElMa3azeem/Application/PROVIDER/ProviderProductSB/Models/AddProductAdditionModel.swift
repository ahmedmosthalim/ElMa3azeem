//
//  AddProductAdditionModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import Foundation

// MARK: - AddProductAdditionModelElement
struct AddProductAdditionToApiModel: Codable {
    var nameAr, nameEn: String
    var price, additiveCategoryID: Int

    enum CodingKeys: String, CodingKey {
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case price = "price"
        case additiveCategoryID = "additive_category_id"
    }
}


struct AddProductAdditionModel: Codable {
    var nameAr, nameEn: String
    var price : String
    var additiveCategory: GeneralPicker
    
    enum CodingKeys: String, CodingKey {
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case price = "price"
        case additiveCategory = "additive_category"
    }
}

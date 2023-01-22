//
//  AdditivesModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 20/11/2022.
//

import Foundation

struct AdditionModel: Codable,GeneralPickerModel {
    var pickerId: Int { return id }
    var pickerTitle: String { return name}
    var pickerKey: String {return ""}
    
    let id: Int
    let nameAr, nameEn, createdAt: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case createdAt = "created_at"
    }
}

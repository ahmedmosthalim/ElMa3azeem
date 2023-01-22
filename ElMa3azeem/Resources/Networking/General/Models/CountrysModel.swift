//
//  CountrysModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation

// MARK: - CountrysModel
struct CountrysModel: Codable {
    let countries: [Country]
}

// MARK: - Country
struct Country: Codable, GeneralPickerModel {
    
    
    let id: Int
    let name, currency, currencyCode, iso2: String
    let iso3, callingCode: String
    let flag: String
    let example : String
    let currencyCodeAr : String
    let currencyCodeEn : String
    
    enum CodingKeys: String, CodingKey {
        case id, name, currency
        case currencyCode = "currency_code"
        case currencyCodeAr = "currency_code_ar"
        case currencyCodeEn = "currency_code_en"
        case iso2, iso3
        case callingCode = "calling_code"
        case flag , example
    }
    
    var pickerId: Int { return id }
    var pickerTitle: String { return name }
    var pickerKey: String { return callingCode }
    
}




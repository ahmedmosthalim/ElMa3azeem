//
//  HomeModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import Foundation

// MARK: - Datum
struct HomeModel: Codable {
    let category, size: String?
    let rows: Int?
    let ads: [Ad]?
    let type: String?
    let stores: [Store]?
    let categories: [Category]?
}

// MARK: - Ad
struct Ad: Codable {
    let content, title: String?
    let cover, image: String?
    let id: Int?
}

// MARK: - Category
struct Category: Codable , GeneralPickerModel{
    let image: String?
    let slug: String?
    let id: Int?
    let name: String?
    
    var pickerId: Int { return id ?? 0 }
    var pickerTitle: String {return name ?? "" }
    var pickerKey: String {return slug ?? ""}
}
// MARK: - SubCategory
struct SubCategory: Codable , GeneralPickerModel{
    let image: String?
    let slug: String?
    let id: Int?
    let name: String?
    
    var pickerId: Int { return id ?? 0 }
    var pickerTitle: String {return name ?? "" }
    var pickerKey: String {return slug ?? ""}
}


// MARK: - Store
struct Store: Codable {
    let id: Int?
    let rate: String?
    let distance, name: String?
    let categoryName: String?
    let long: String?
    let icon: String?
    let address, lat: String?
    let isOpen, available : Bool? 

    enum CodingKeys: String, CodingKey {
        case rate, id
        case isOpen = "is_open"
        case categoryName = "category_name"
        case available, distance, name, long, icon, address, lat
    }
}

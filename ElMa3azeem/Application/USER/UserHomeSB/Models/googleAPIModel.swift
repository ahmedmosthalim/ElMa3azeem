//
//  googleAPIModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//
import Foundation

struct googleAPIModel : Codable {
    var errorMsg:String?
    var results:[result]
    var status:String?
    
    enum CodingKeys:String,CodingKey {
        case errorMsg = "error_message"
        case results
        case status
    }
}

// MARK: -
struct result: Codable {
    var addressComponents: [AddressComponent]?
    var formattedAddress: String?
    var geometry: Geometry?
    var placeID: String?
    var plusCode: PlusCode?
    var types: [String]?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case plusCode = "plus_code"
        case types
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    var longName, shortName: String?
    var types: [String]?

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    var location: Location?
    var locationType: String?
    var viewport: Viewport?

    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport
    }
}

// MARK: - Location
struct Location: Codable {
    var lat, lng: Double?
}

// MARK: - Viewport
struct Viewport: Codable {
    var northeast, southwest: Location?
}

// MARK: - PlusCode
struct PlusCode: Codable {
    var compoundCode, globalCode: String?

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}


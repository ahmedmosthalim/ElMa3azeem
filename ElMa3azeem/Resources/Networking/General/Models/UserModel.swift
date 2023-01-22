//
//  UserModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation

// MARK: - UserModel

struct UserModel: Codable {
    let token               : String?
    let telegram            : String?
    let user                : User?
    let registeredSocial    : Bool?
    let phoneRegistered     : Bool?
}

// MARK: - User
struct User: Codable, CodableInit {
//    
//    let accType, address: String
//    let avatar: String
//    let carBack, carFront: String
//    let carModel: String
//    let carModelID: Int
//    let changedPhone: String
//    let city: CityUserModel
//    let completedInfo: Bool
//    let countryKey, date: String
//    let email, fullname: String
//    let id: Int
//    let lat, long, name: String
//    let newOrdersNotify: Bool
//    let numComments, numOrders: String
//    let offersNotify: Bool
//    let phone, rate: String
//    let regionID: Int
//    let regionName, timeZone, totalBills, totalDeliveryFees: String
//    let wallet: String
//    let gender:String?
//    let cityId ,nationalityId:Int?
//    var  carPlateInNum , carPlateInLetters ,manufacturingYear : String?
//    var  driverLicense : String?
//    
//    
//    var accountType: AccountType {
//        switch accType {
//        case AccountType.user.rawValue:
//            return .user
//        case AccountType.delegate.rawValue:
//            return .delegate
//        case AccountType.provider.rawValue:
//            return .provider
//        default:
//            return .unknown
//        }
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case accType = "acc_type"
//        case address, avatar
//        case carBack = "car_back"
//        case carFront = "car_front"
//        case carPlateInLetters = "car_letters"
//        case carModel = "car_model"
//        case carModelID = "car_model_id"
//        case carPlateInNum = "car_numbers"
//        case changedPhone = "changed_phone"
//        case city
//        case completedInfo = "completed_info"
//        case countryKey = "country_key"
//        case date
//        case email, fullname, id, lat, long
//        case manufacturingYear = "manufactoring_year"
//        case name
//        case newOrdersNotify = "new_orders_notify"
//        case numComments = "num_comments"
//        case numOrders = "num_orders"
//        case offersNotify = "offers_notify"
//        case phone, rate
//        case regionID = "region_id"
//        case regionName = "region_name"
//        case timeZone = "time_zone"
//        case totalBills = "total_bills"
//        case totalDeliveryFees = "total_delivery_fees"
//        case wallet
//        case gender
//        case nationalityId = "nationality_id"
//        case cityId  = "city_id"
//        case driverLicense = "driving_license"
////        case regionId = "region_id"
//    }

//    =======
//
    var id: Int
    var name, email, countryKey: String
    var completedInfo: Bool
    var phone, changedPhone: String
    var avatar: String?
    var lat, long, address, rate: String?
    var wallet, totalBills, totalDeliveryFees, numOrders: String?
    var numComments, accType, timeZone, date: String?
    var newOrderNotify, offerNotify: Bool?
    var fullName: String?
    var gender : String?
    var nationalityId : Int?
    var regionId : Int?
    var cityId : Int?
    var carModel , carPlateInNum , carPlateInLetters ,manufacturingYear : String?
    var carFront , carBack , driverLicense : String?
    var accountType: AccountType {
        switch accType {
        case AccountType.user.rawValue:
            return .user
        case AccountType.delegate.rawValue:
            return .delegate
        case AccountType.provider.rawValue:
            return .provider
        default:
            return .unknown
        }
    }
    var city : CityUserModel?



    enum CodingKeys: String, CodingKey {
        case id, name, email
        
    
        case completedInfo = "completed_info"
        case countryKey = "country_key"
        case phone, avatar, lat, long, address, rate, wallet
        case totalBills = "total_bills"
        case totalDeliveryFees = "total_delivery_fees"
        case numOrders = "num_orders"
        case numComments = "num_comments"
        case accType = "acc_type"
        case timeZone = "time_zone"
        case date
        case city
        case changedPhone = "changed_phone"
        case newOrderNotify = "new_orders_notify"
        case offerNotify = "offers_notify"
        case gender
        case nationalityId = "nationality_id"
        case regionId  = "region_id"
        case cityId = "city_id"
        case carModel =  "car_model"
        case carPlateInNum = "car_numbers"
        case carPlateInLetters =  "car_letters"
        case manufacturingYear = "manufactoring_year"
        case carFront = "car_front"
        case carBack = "car_back"
        case driverLicense = "driving_license"
    }
}


// MARK: - City
struct CityUserModel: Codable {
    
    let id: Int
    let name: String?
    let center: String?
    let regionID: Int
    
    
    
    let citcCityID: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        
        case id, name, center
        case regionID = "region_id"
        
        
        case citcCityID = "citc_cityId"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

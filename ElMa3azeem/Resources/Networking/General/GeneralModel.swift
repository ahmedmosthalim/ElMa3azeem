//
//  GeneralModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//


import Foundation

struct GeneralModel<T : Codable> : Codable , CodableInit{
    let userStatus, msg, key: String
    let code: Int
    let data: T?

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

struct GeneralData : Codable {
    let available : Bool?
}

struct UnSeenNotificationModel : Codable , CodableInit{
    let numNotSeenNotifications : Int
    enum CodingKeys: String, CodingKey {
        case numNotSeenNotifications = "num_not_seen_notifications"
    }
}

protocol GeneralPickerModel : Codable {
    var pickerId : Int {get}
    var pickerTitle : String {get}
    var pickerKey : String{get}
}

struct GeneralPicker : GeneralPickerModel{
    var id : Int = 0
    var title : String = ""
    var key : String = ""
    
    var pickerId : Int { return id}
    var pickerTitle : String { return title}
    var pickerKey: String {return key}
}

struct CitiesModel: Codable , GeneralPickerModel {
    var id: Int = 0
    var name: String = ""
    
    var pickerId : Int { return id}
    var pickerTitle : String { return name}
    var pickerKey: String {return ""}
}

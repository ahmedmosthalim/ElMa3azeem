//
//  carTypesModel.swift
//  ElMa3azeem
//
//  Created by Ahmed Mostafa on 27/11/2022.
//

import Foundation
struct CarTypesModel : Codable, CodableInit , GeneralPickerModel{
    var pickerId: Int{
        return id
    }
    
    var pickerTitle: String{
        return name
    }
    
    var pickerKey: String{
        return ""
    }
    
    
   var  id   :Int
   var  name :String
}
struct RegionModel : Codable , CodableInit , GeneralPickerModel
{
    var pickerId: Int{
        return id
    }
    var pickerTitle: String{
        return name
    }
    var pickerKey: String {
        return ""
    }
    var  id   :Int
    var  name :String
}

enum CodingKeys: String, CodingKey {
    case id
    case name
}



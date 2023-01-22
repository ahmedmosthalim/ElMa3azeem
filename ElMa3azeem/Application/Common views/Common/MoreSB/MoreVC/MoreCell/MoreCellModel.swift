//
//  MoreCellModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Foundation
import UIKit

/*
 I have use image as string because
 the time we have developed the app
 image Literal not working
 and keep MVP role 
 */

struct MoreCellModel {
    let title : String
    let image : String
    
    init(title:String , image : String ) {
        self.title = title
        self.image = image
    }
}


//struct MoreCellModel {
//    let title : String
//    let image : String
//    let action : (()->())!
//}

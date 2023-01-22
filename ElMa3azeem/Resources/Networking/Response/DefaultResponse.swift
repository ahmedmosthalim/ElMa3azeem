//
//  DefaultResponse.swift
//  SwiftCairo-App
//
//  Created by abdelrahman mohamed on 4/2/18.
//  Copyright © 2018 abdelrahman mohamed. All rights reserved.
//

import Foundation

/// Default response to check for every request since this's how this api works. 
struct DefaultResponse: Codable, CodableInit {
    let userStatus, msg: String?
    let key: String?
    let data: Data?

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, data
        case key
    }
}

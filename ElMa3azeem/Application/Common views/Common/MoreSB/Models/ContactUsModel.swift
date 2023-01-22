//
//  ContactUsModel.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/9/22.
//

import Foundation

// MARK: - ContactUsModel
struct ContactUsModel: Codable, CodableInit {
    let userStatus, msg, key: String
    let code: Int

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code
    }
}


//
//  chatFileResponse.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 01/11/2022.
//

import Foundation

// MARK: - chatFileResponse
struct chatFileResponse: Codable,CodableInit {
    let userStatus, msg, key: String
    let code: Int
    let data: chatFileData

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

// MARK: - chatFileData
struct chatFileData: Codable {
    let name: String
    let url: String
    let duration: String
}

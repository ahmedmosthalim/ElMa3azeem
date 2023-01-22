//
//  WalletModel.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/4/22.
//

import Foundation

// MARK: - WalletModel
struct WalletModel: Codable,CodableInit {
    let userStatus, msg, key: String
    let code: Int
    let data: WalletData

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

// MARK: - WalletData
struct WalletData: Codable {
    let wallet: String
}


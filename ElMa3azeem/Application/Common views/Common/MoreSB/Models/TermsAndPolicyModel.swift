//
//  TermsAndPolicyModel.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/5/22.
//

import Foundation

// MARK: - TermsAndPolicyModel

struct TermsAndPolicyModel: Codable {
    let userStatus, msg, key: String
    let code: Int
    let data: TermsAndPolicy

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

// MARK: - DataClass

struct TermsAndPolicy: Codable {
    let policy, terms, about: String?
}

//
//  ReviewsModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import Foundation


// MARK: - DataClass
struct ReviewsModel: Codable {
    let reviews: [Review]
}

// MARK: - Review
struct Review: Codable {
    let comment, userName, createdAt: String
    let id: Int
    let rate: String
    let userAvatar: String

    enum CodingKeys: String, CodingKey {
        case comment
        case userName = "user_name"
        case createdAt = "created_at"
        case id, rate
        case userAvatar = "user_avatar"
    }
}

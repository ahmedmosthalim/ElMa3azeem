//
//  UserReviewsModel.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/5/22.
//

import Foundation

// MARK: - UserViewsModel
struct UserViewsModel: Codable,CodableInit {
    let userStatus, msg, key: String
    let code: Int
    let data: ReviewsData

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

// MARK: - ReviewsData
struct ReviewsData: Codable {
    let reviews: [Reviews]
}

// MARK: - Review
struct Reviews: Codable {
    let id: Int
    let userName: String
    let userAvatar: String
    let rate, comment, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case userAvatar = "user_avatar"
        case rate, comment
        case createdAt = "created_at"
    }
}

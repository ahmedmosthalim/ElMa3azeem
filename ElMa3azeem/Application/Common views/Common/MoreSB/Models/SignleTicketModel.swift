//
//  SignleTicketModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/01/2022.
//

import Foundation

// MARK: - SingleTicketData
struct SignleTicketModel: Codable {
    let ticket: SignleTicketData
}

// MARK: - Ticket
struct SignleTicketData: Codable {
    let id: Int
    let createdAt, status, otherMemberName: String
    let otherMemberAvatar: String
    let subject, text: String
    let order: Order
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case status
        case otherMemberName = "other_member_name"
        case otherMemberAvatar = "other_member_avatar"
        case subject, text, order, images
    }
}

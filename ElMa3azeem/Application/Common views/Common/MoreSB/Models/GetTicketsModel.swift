//
//  GetTicketsModel.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/4/22.
//

import Foundation

// MARK: - TicketModel
struct TicketModel: Codable {
    let tickets: [Ticket]
}

// MARK: - Ticket
struct Ticket: Codable {
    let id: Int
    let createdAt, status, text: String
    let order: TicketsOrder

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case status, text, order
    }
}

// MARK: - Order
struct TicketsOrder: Codable {
    let id: Int
    let createdAt, status: String
    let image: String
    let name, distanceToReceiveAddress, distanceToDeliverAddress: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case status, image, name
        case distanceToReceiveAddress = "distance_to_receive_address"
        case distanceToDeliverAddress = "distance_to_deliver_address"
    }
}


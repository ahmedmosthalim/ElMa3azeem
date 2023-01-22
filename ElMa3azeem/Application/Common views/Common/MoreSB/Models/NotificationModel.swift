//
//  NotificationModel.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 111/22.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let notifications: [NotificationData]
    let pagination: Pagination?
}

// MARK: - Notification
struct NotificationData: Codable {
    let id: String?
    let icon: String?
    let title, message, type: String?
    let orderID: Int?
    let orderOwner : Int?
    let notificationType, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, icon, title, message, type
        case orderID = "order_id"
        case orderOwner = "order_owner"
        case notificationType = "notification_type"
        case createdAt = "created_at"
    }
}

//
//  ChatModel.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 16/01/2022.
//

import UIKit

struct MessageModel {
    var imageFromMe             : UIImage?
    var videoFromMe             : String?
    var cashedVideoFrameImage   : UIImage?
    var msg                     : Message
    var selected                : Bool = false
}


// MARK: - ChatResponse
struct ChatResponse: Codable ,CodableInit{
    
    let userStatus, msg, key: String
    let code                : Int
    let data                : ChatData

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
        case msg, key, code, data
    }
}

// MARK: - DataClass
struct ChatData: Codable {
    let room: Room
}

// MARK: - Room
struct Room: Codable {
    let id                  : Int
    let date, time, status  : String
    let messages            : [Message]
    let pagination          : Pagination
}

// MARK: - Message
struct Message: Codable {
    let id                  : Int
    let content             : String
    let avatar              : String
    let type, date, time    : String
    let sentByMe            :Bool
    let duration            : Double
    
    enum CodingKeys: String, CodingKey {
        case id, content, avatar, type, date, time,duration
        case sentByMe = "sent_by_me"
    }
}



// MARK: - MessageSocketModel
struct MessageSocketModel: Codable {
    let content     : String
    let receiverID, roomID, senderID: Int
    let type        : String
    let duration    : String?

    enum CodingKeys: String, CodingKey {
        case content
        case receiverID = "receiver_id"
        case roomID     = "room_id"
        case senderID   = "sender_id"
        case type
        case duration
    }
}

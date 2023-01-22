//
//  OrderDetailsModel.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 3011/2022.
//

import Foundation

// MARK: - DataClass
struct UserOrderDetailsModel: Codable , CodableInit {
    var order: OrderDetails
}

// MARK: - Order
struct OrderDetails: Codable , CodableInit {
    var id: Int
    var createdAt, status, deliverTime, paymentType: String?
    var deliverAddress, type: String?
    var needsDelivery : Bool?
    var deliveryPrice, price, appPercentage, addedValue: String?
    var discount, totalPrice, orderDescription: String?
    var products: [Products]?
    var receiveAddress : String?
    var delegateName, delegatePhone, delegateAvatar, userName: String?
    var userPhone: String?
    var userAvatar: String?
    var invoiceImage , closeReason : String?
    var canWithdraw , haveInvoice: Bool?
    var userId : Int?
    var roomID: Int?
    var images: [Image]?
    var store: Store?
    var timer : Int?
    var delegateID : Int?
    var paymentMethod : PaymentMethod?
    var paymentStatus : Bool?
    var deliveryOffers : [OrderOfferModel]?
    let deliverLat, deliverLong, receiveLat , receiveLong: String?
    var delegateLat , delegateLong : String?

    
    var orderType: OrderType {
        switch self.type {
        case OrderType.specialStoreWithDelivery.rawValue:
            return .specialStoreWithDelivery
        case OrderType.googleStore.rawValue:
            return .googleStore
        case OrderType.parcelDelivery.rawValue:
            return .parcelDelivery
        case OrderType.specialPackage.rawValue:
            return .specialPackage
        default:
            return .defult
        }
    }
    
    var orderStatus: OrderStatus {
        switch self.status {
            
        case OrderStatus.pending.rawValue:
            return OrderStatus.pending
        case OrderStatus.inProgrese.rawValue:
            return OrderStatus.inProgrese
        case OrderStatus.prepared.rawValue:
            return OrderStatus.prepared
        case OrderStatus.inTransit.rawValue:
            return OrderStatus.inTransit
        case OrderStatus.finished.rawValue:
            return OrderStatus.finished
        case OrderStatus.recherStore.rawValue:
            return OrderStatus.recherStore
        case OrderStatus.invoiceCreated.rawValue:
            return OrderStatus.invoiceCreated
        case OrderStatus.reachedReciveLocation.rawValue:
            return OrderStatus.reachedReciveLocation
        case OrderStatus.reachedDeliveryLocation.rawValue:
            return OrderStatus.reachedDeliveryLocation
        case OrderStatus.canceld.rawValue:
            return .canceld
        default:
            return .defult
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case userId = "user_id"
        case status
        case deliverLat = "deliver_lat"
        case deliverLong = "deliver_long"
        case receiveLat = "receive_lat"
        case receiveLong = "receive_long"
        case closeReason = "close_reason"
        case invoiceImage = "invoice_image"
        case deliverTime = "deliver_time"
        case paymentType = "payment_type"
        case deliverAddress = "deliver_address"
        case haveInvoice = "have_invoice"
        case needsDelivery = "needs_delivery"
        case type
        case receiveAddress = "receive_address"
        case canWithdraw = "can_withdraw"
        case timer
        case deliveryPrice = "delivery_price"
        case price
        case appPercentage = "app_percentage"
        case addedValue = "added_value"
        case discount
        case totalPrice = "total_price"
        case orderDescription = "description"
        case products
        case delegateName = "delegate_name"
        case delegatePhone = "delegate_phone"
        case delegateAvatar = "delegate_avatar"
        case userName = "user_name"
        case userPhone = "user_phone"
        case userAvatar = "user_avatar"
        case roomID = "room_id"
        case images
        case store
        case delegateID = "delegate_id"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case deliveryOffers = "delivery_offers"
        case delegateLat = "delegate_lat"
        case delegateLong = "delegate_long"
    }
}

// MARK: - Product
struct Products: Codable {
    var id: Int
    var image: String
    var name, price: String
    var qty: Int
    var additives: String
}

// MARK: - Product
struct Image: Codable {
    var id: Int
    var url: String
}

// MARK: - OrderOffer
struct OrderOfferModel: Codable {
    var delegateAvatar: String
    var price: String
    var id: Int
    var notes, delegateName: String

    enum CodingKeys: String, CodingKey {
        case delegateAvatar = "delegate_avatar"
        case price, id, notes
        case delegateName = "delegate_name"
    }
}

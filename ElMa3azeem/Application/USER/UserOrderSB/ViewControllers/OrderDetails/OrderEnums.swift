//
//  OrderEnums.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2811/2022.
//

import Foundation
enum OrderType : String, Codable {
    case specialStoreWithDelivery = "special_stores"
    case googleStore = "google_places"
    case parcelDelivery = "parcel_delivery"
    case specialPackage = "special_request"
    case defult
}

enum OrderStatus: String, Codable {
    //All
    case pending = "pending"
    //All expet parcelDelivery
    case inProgrese = "inprogress"
    // specialStoreWithDelivery, googleStore, parcelDelivery
    case prepared = "prepared"
    // specialStoreWithDelivery, specialPackage
    case inTransit = "intransit"
    // All
    case finished = "finished"
    // googleStore
    case recherStore = "reached_store"
    // googleStore
    case invoiceCreated = "invoice_created"
    // parcelDelivery
    case reachedReciveLocation = "reached_receive_location"
    // parcelDelivery
    case reachedDeliveryLocation = "reached_deliver_location"
    
    case canceld = "canceled"
    
    case defult
}

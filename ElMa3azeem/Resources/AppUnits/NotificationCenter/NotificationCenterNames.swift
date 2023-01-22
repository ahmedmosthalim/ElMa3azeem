//
//  NotificationCenterNames.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation

extension Notification.Name {
    static let reloadHomeTableView = Notification.Name("reloadHomeTableView")
    static let reloadMyDeliveryTableView = Notification.Name("reloadMyDeliveryTableView")
    static let reloadMyOrderTableView = Notification.Name("reloadMyOrderTableView")
    static let reloadUserOrderDetails = Notification.Name("reloadUserOrderDetails")
    static let reloadDelegateOrderDetails = Notification.Name("reloadDelegateOrderDetails")
    static let reloadProviderOrderDetails = Notification.Name("reloadProviderOrderDetails")
    static let reloadProviderTableView = Notification.Name("reloadProviderTableView")
    static let reloadNotificationCount = Notification.Name("reloadNotificationCount")
    static let reloadNotificationFromFCM = Notification.Name("reloadNotificationFromFCM")
    static let disConnectSocket = Notification.Name("disConnectSocket")
    
}


//
//  NotificationService.swift
//  com.aait.HomeCooking
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 22/11/2022.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            
            
            // Modify the notification content here...
            let bodyEn = bestAttemptContent.userInfo[AnyHashable("message_en")] as? String ?? ""
            let bodyAr = bestAttemptContent.userInfo[AnyHashable("message_ar")] as? String ?? ""
            
            let titleEn = bestAttemptContent.userInfo[AnyHashable("title_en")] as? String ?? ""
            let titleAr = bestAttemptContent.userInfo[AnyHashable("title_ar")] as? String ?? ""
            
            if let userDefaults = UserDefaults(suiteName: "group.ElMa3azeem") {
                if let lang = userDefaults.string(forKey: "lang") {
                    bestAttemptContent.body = "\((lang == "en") ? bodyEn : bodyAr)"
                    bestAttemptContent.title = "\((lang == "en") ? titleEn : titleAr)"
                } else {
                    bestAttemptContent.body = "\(bodyAr)"
                    bestAttemptContent.title = "\(titleAr)"
                }
            }
            
            contentHandler(bestAttemptContent)
        }

    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

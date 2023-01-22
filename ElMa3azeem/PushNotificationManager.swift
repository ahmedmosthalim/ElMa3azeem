//
//  PushNotificationManager.swift
//  WawProvider
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 26/11/2022.
//

import FBSDKLoginKit
import Firebase
import UIKit

enum notificationType: String {
    // common
    case newReview = "new_review" // -> تقييم جديد
    case newMessage = "new_message" // -> رسالة جديدة
    case blockNotify = "block_notify" // -> تم حظر الحساب
    case deleteNotify = "delete_notify" // -> تم حذف الحساب

    // delegate
    case payWithWallet = "pay_with_wallet" // -> الدفع بالمحفظة
    case newOrde = "new_order" // -> هناك طلب جديد
    case userAcceptedOffer = "user_accepted_offer" // -> العميل وافق على العرض
    case userRejectedOffer = "user_rejected_offer" // ->العميل رفض العرض
    case changePaymentMethod = "change_payment_method" // -> تغيير طريقة الدفع
    case orderIsPaid = "order_is_paid" // -> تم الدفع
    case orderIsReady = "order_is_ready" // -> قام مقدم الخدمة بتجهيز الطلب
    case storeRefuseOrder = "store_refuse_order" // -> قام مقدم الخدمة برفض الطلب
    case userCancelOrder = "user_cancel_order" // -> قام العميل بالغاء الطلب

    // user
    case withdrawOrder = "withdraw_order" // -> المندوب انسحب من الطلب
    case acceptJoinRequest = "accept_join_request" // -> تم قبول طلب الانضمام ك مندوب
    case delegateFinishedOrder = "delegate_finished_order" // -> المندوب انهى الطلب
    case delegateMadeOffer = "delegate_made_offer" // -> المندوب قدم عرض
    case orderIntransit = "order_intransit" // -> الطلب قيد التوصيل
    case delegateCreatedInvoice = "delegate_created_invoice" // -> المندوب انشأ فاتورة
    case delegateAcceptedOffer = "delegate_accepted_offer" // ->المندوب قبل عرض التوصيل
    case storeAcceptOrder = "store_accept_order" // -> لما المتجر يقبل الطلب
    case adminNotify = "admin_notify"
    
    
    
}

extension Notification.Name {
    static let messageNotify = Notification.Name("messageNotify")
}

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "No Devies token found")")
//        UserDefaults.pushNotificationToken = fcmToken ?? "No Token Found"
        AppDelegate.FCMToken = fcmToken ?? "No Token Found"
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    static var isOpenNotification = false

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }

    // MARK: - Handel the arrived Notifications

    // MARK: - Use this method to process incoming remote notifications for your app

    // when fcm comes
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    }

    // MARK: - ============================ when Show Notification ==========================

    // when the notification arrives and the app is in forground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Notification info is: \n\(userInfo)")

        let orderID = userInfo[AnyHashable("order_id")] as? String
//        let orderOwner = userInfo[AnyHashable("order_owner")] as? String
        let dic = ["id": orderID]
        guard let accountType = defult.shared.user()?.user?.accountType else { return }
        guard let targetValue = userInfo[AnyHashable("type")] as? String else { return }
        NotificationCenter.default.post(name: .reloadNotificationFromFCM, object: nil)

        switch targetValue {
        // user
        case notificationType.withdrawOrder.rawValue,
             notificationType.delegateFinishedOrder.rawValue,
             notificationType.delegateMadeOffer.rawValue,
             notificationType.orderIntransit.rawValue,
             notificationType.delegateCreatedInvoice.rawValue,
             notificationType.storeAcceptOrder.rawValue,
             notificationType.delegateAcceptedOffer.rawValue,
             notificationType.userRejectedOffer.rawValue,
             notificationType.payWithWallet.rawValue,
             notificationType.userAcceptedOffer.rawValue,
             notificationType.orderIntransit.rawValue,
             notificationType.newOrde.rawValue,
             notificationType.orderIsPaid.rawValue,
             notificationType.changePaymentMethod.rawValue,
             notificationType.storeRefuseOrder.rawValue,
             notificationType.storeAcceptOrder.rawValue,
             notificationType.userCancelOrder.rawValue,
             notificationType.orderIsReady.rawValue:

            switch accountType {
            case .user:
                NotificationCenter.default.post(name: .reloadUserOrderDetails, object: nil, userInfo: dic as [AnyHashable: Any])
                NotificationCenter.default.post(name: .reloadMyOrderTableView, object: nil)
            case .delegate:
                NotificationCenter.default.post(name: .reloadDelegateOrderDetails, object: nil, userInfo: dic as [AnyHashable: Any])
                NotificationCenter.default.post(name: .reloadMyDeliveryTableView, object: nil)
            case .provider:
                NotificationCenter.default.post(name: .reloadProviderOrderDetails, object: nil, userInfo: dic as [AnyHashable: Any])
                NotificationCenter.default.post(name: .reloadProviderTableView, object: nil)
            case .unknown:
                break
            }

        case notificationType.deleteNotify.rawValue,
             notificationType.acceptJoinRequest.rawValue:
            resetApp()
        default:
            break
        }

        completionHandler([.list, .banner, .sound])
    }

    // MARK: - ============================ User must tap ==========================

    // when the user tap on the notification banar background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("Notification info is: \n\(userInfo)")
        guard let targetValue = userInfo[AnyHashable("type")] as? String else { return }
        let orderID = userInfo[AnyHashable("order_id")] as? String
        let roomID = userInfo[AnyHashable("room_id")] as? String
//        let reciverID = userInfo[AnyHashable("receiver_id")] as? String
        let senderID = userInfo[AnyHashable("sender")] as? String
//        let orderOwner = userInfo[AnyHashable("order_owner")] as? String
        guard let accountType = defult.shared.user()?.user?.accountType else { return }

        guard let root = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController else { return }
        let home = root.viewControllers?[0] as! HomeNavigationController
        root.selectedIndex = 0
        root.navigationController?.popToRootViewController(animated: true)
        let currentVC = home.visibleViewController

        print("Notification Tapped from forground 📱🔔")
        print("Notification Type 🥶 \(targetValue)")

        switch targetValue {
        // commn
        case notificationType.newMessage.rawValue:
            if currentVC?.isKind(of: ChatVC.self) == false {
                let chat = UIStoryboard(name: StoryBoard.Chat.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                chat.roomID = Int(roomID ?? "") ?? 0
                chat.recieverId = Int(senderID ?? "") ?? 0
                chat.senderId = defult.shared.user()?.user?.id ?? 0
                chat.orderState = .inProgrese
                home.pushViewController(chat, animated: true)
            }

        case notificationType.newReview.rawValue:

            if currentVC?.isKind(of: UserCommentVC.self) == false {
                let userCommentVC = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil).instantiateViewController(withIdentifier: "UserCommentVC") as! UserCommentVC
                userCommentVC.isFromMore = true
                home.pushViewController(userCommentVC, animated: true)
            }

        // delegate
        case notificationType.newOrde.rawValue, notificationType.changePaymentMethod.rawValue, notificationType.userRejectedOffer.rawValue, notificationType.userAcceptedOffer.rawValue, notificationType.orderIsPaid.rawValue, notificationType.payWithWallet.rawValue, notificationType.storeRefuseOrder.rawValue,
             notificationType.userCancelOrder.rawValue:

            switch accountType {
            case .user:
                if currentVC?.isKind(of: UserOrderDetailsVC.self) == false {
                    let vc = AppStoryboards.Order.instantiate(UserOrderDetailsVC.self)
                    vc.orderID = Int(orderID ?? "") ?? 0
                    vc.isFromFCM = true
                    home.pushViewController(vc, animated: true)
                }
            case .delegate:
                if currentVC?.isKind(of: DelegateOrderDetailsVC.self) == false {
                    let vc = AppStoryboards.Delegate.instantiate(DelegateOrderDetailsVC.self)
                    vc.orderID = Int(orderID ?? "") ?? 0
                    vc.isFromFCM = true
                    home.pushViewController(vc, animated: true)
                }
            case .provider:
                if currentVC?.isKind(of: ProviderOrderDetailsVC.self) == false {
                    let vc = AppStoryboards.ProviderOrder.instantiate(ProviderOrderDetailsVC.self)
                    vc.orderID = Int(orderID ?? "") ?? 0
                    vc.isFromFCM = true
                    home.pushViewController(vc, animated: true)
                }
            case .unknown:
                break
            }

        // user
        case notificationType.delegateMadeOffer.rawValue, notificationType.delegateCreatedInvoice.rawValue, notificationType.delegateAcceptedOffer.rawValue, notificationType.delegateFinishedOrder.rawValue, notificationType.orderIntransit.rawValue, notificationType.storeAcceptOrder.rawValue, notificationType.withdrawOrder.rawValue:

            if currentVC?.isKind(of: UserOrderDetailsVC.self) == false {
                let orderDetails = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil).instantiateViewController(withIdentifier: "UserOrderDetailsVC") as! UserOrderDetailsVC
                orderDetails.orderID = Int(orderID ?? "") ?? 0
                home.pushViewController(orderDetails, animated: true)
            }

        case notificationType.acceptJoinRequest.rawValue:
            resetApp()

        case notificationType.orderIsReady.rawValue:

            switch accountType {
            case .user:
                if currentVC?.isKind(of: UserOrderDetailsVC.self) == false {
                    let vc = AppStoryboards.Order.instantiate(UserOrderDetailsVC.self)
                    vc.orderID = Int(orderID ?? "") ?? 0
                    vc.isFromFCM = true
                    home.pushViewController(vc, animated: true)
                }
            case .delegate:
                if currentVC?.isKind(of: DelegateOrderDetailsVC.self) == false {
                    let vc = AppStoryboards.Delegate.instantiate(DelegateOrderDetailsVC.self)
                    vc.orderID = Int(orderID ?? "") ?? 0
                    vc.isFromFCM = true
                    home.pushViewController(vc, animated: true)
                }
            case .provider:
                if currentVC?.isKind(of: ProviderOrderDetailsVC.self) == false {
                    let vc = AppStoryboards.ProviderOrder.instantiate(ProviderOrderDetailsVC.self)
                    vc.orderID = Int(orderID ?? "") ?? 0
                    vc.isFromFCM = true
                    home.pushViewController(vc, animated: true)
                }
            case .unknown:
                break
            }
        default:
            print("case not found ❌")
        }

        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }

    static func changeWindowRoot(vc: UIViewController) {
        UIApplication.shared.windows[0].rootViewController = vc
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    func resetApp() {
        defult.shared.removeAll()
        SocketConnection.sharedInstance.socket.disconnect()
        UserDefaults.standard.removeObject(forKey: "token")
        defult.shared.removeAll()
        let mangare = LoginManager()
        mangare.logOut()

        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil)
        var vc: UIViewController
        vc = sb.instantiateViewController(withIdentifier: "CustomNavigationController")
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .showHideTransitionViews, animations: nil, completion: nil)
    }
}

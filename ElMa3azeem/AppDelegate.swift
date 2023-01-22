//
//  AppDelegate.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import FirebaseCore
import CoreLocation
import Cosmos
import FBSDKCoreKit
import Firebase
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import UIKit

 @main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var window: UIWindow?
    static let appGroupKey = "group.ElMa3azeem"
    let gcmMessageIDKey = "gcm.message_id"
    static var FCMToken = "xnx'_'xnx"
    static let GoogleAPI = "AIzaSyALVzDd_-YceNQIpzRFq0w60jTU3RhV22I"
    static let signInConfig = GIDConfiguration(clientID: "222066532190-8en7mr8ns4asjctk2ljgkg5fkl26ctim.apps.googleusercontent.com")

    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        NVActivityIndicatorView.DEFAULT_TYPE = .lineScalePulseOut
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.appColor(.MainColor)!

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "done".localized
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.toolbarTintColor = .appColor(.MainColor)
        
        UIToolbar.appearance().tintColor = .appColor(.MainColor)!
        UIPickerView.appearance().tintColor = .appColor(.MainColor)!
        UILabel.appearance().substituteFontName = "URWDINArabic"
        UITextView.appearance().substituteFontName = "URWDINArabic"
        UITextField.appearance().substituteFontName = "URWDINArabic"
//        UIApplication.shared.statusBarStyle = .lightContent

        // MARK: - Localization
        Language.handleViewDirection()
        Bundle.swizzleLocalization()
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        GMSServices.provideAPIKey(AppDelegate.GoogleAPI)
        GMSPlacesClient.provideAPIKey(AppDelegate.GoogleAPI)

        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        if let luanch = defult.shared.getData(forKey: .isFiristLuanch) {
            print(luanch)
        } else {
            defult.shared.setData(data: true, forKey: .isFiristLuanch)
        }

        if let userDefaults = UserDefaults(suiteName: AppDelegate.appGroupKey) {
            if let lang = userDefaults.string(forKey: "AppleLanguages") {
                print(lang)
            } else {
                userDefaults.setValue("\(Language.currentLanguage())", forKey: "AppleLanguages")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // facebook login
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    

//        Google login
//        let handled: Bool
//        handled = GIDSignIn.sharedInstance.handle(url)
        GIDSignIn.sharedInstance.handle(url)
        return true
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }
}

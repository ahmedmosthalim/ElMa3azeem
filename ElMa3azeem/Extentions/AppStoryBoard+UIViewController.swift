//
//  AppStoryBoard+UIViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

public enum AppStoryboards: String {
    // COMMON
    case Auth
    case More
    case Chat
    
    // USER
    case Home
    case Order
    case MyOrder
    case NormalOrder

    // PROVIDER
    case ProviderHome
    case ProviderPackage
    case ProviderOrder
    case ProviderProduct
    case ProviderMore

    // DELEGATE
    case DelegateHome
    case Delegate
    
    case Payment
}

extension AppStoryboards {
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = UIStoryboard(name: rawValue, bundle: nil) // bundd
            .instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
        else { fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(rawValue)") }
        return vc
    }

    public func instantiateWith(identifier: String) -> UIViewController {
        let vc = UIStoryboard(name: rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return vc
    }

    public func initialVC() -> UIViewController? {
        guard let vc = UIStoryboard(name: rawValue, bundle: nil).instantiateInitialViewController() else { return nil }
        return vc
    }
}

extension UIViewController {
    public static var storyboardIdentifier: String {
        return description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}

struct MGHelper {
    static func changeWindowRoot(vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc

        let window = UIApplication.shared.windows.first { $0.isKeyWindow }

        guard let window = window else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    static func changeWindowRoot(vc: Any) {
//        UIApplication.shared.windows.first?.rootViewController = vc

        let window = UIApplication.shared.windows.first { $0.isKeyWindow }

        guard let window = window else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}

//
//  Alert.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation
import UIKit

class Alert {
    class func showAlert(target: UIViewController, title: String, message: String,Time: Double) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       
        let titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        let messageFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)

        alert.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : titleFont]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : messageFont]), forKey: "attributedMessage")
        target.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Time) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    class func showAlertWithAction(target: UIViewController, title: String, message: String, okAction: String, actionCompletion: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okAction , style: .default, handler: actionCompletion))
                
        let titleFont: UIFont = .boldSystemFont(ofSize: 16)//UIFont(name: BahijTheSansArabic.bold.rawValue, size: 16) ?? .boldSystemFont(ofSize: 16)
        let messageFont: UIFont = .boldSystemFont(ofSize: 14)//UIFont(name: BahijTheSansArabic.regular.rawValue, size: 14) ?? .boldSystemFont(ofSize: 14)

        alert.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : titleFont]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : messageFont]), forKey: "attributedMessage")
        
        target.present(alert, animated: true, completion: nil)
    }
}

//
//  UIlableExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 28/11/2022.
//

import UIKit

extension UILabel {
    @IBInspectable var isRequired: Bool {
        get {
            let isrequired = self.isRequired
            return isrequired
        }
        
        set {
            if newValue == true {
                let font = UIFont(name: AppFont.Bold.rawValue, size: 14)!

                let firstAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.appColor(.MainFontColor)!,
                    .font: font,
                ]

                let secondAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.red,
                    .font: font,
                ]

                let firstString = NSMutableAttributedString(string: text ?? "", attributes: firstAttributes)
                let secondString = NSAttributedString(string: "  *", attributes: secondAttributes)

                firstString.append(secondString)

                attributedText = firstString
            }
            
        }
    }
}

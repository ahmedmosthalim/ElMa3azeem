//
//  StringExtension.swift
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/9/21.
//  Copyright © 2022 Abdullah Tarek & Ahmed Mostafa Halim. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let attributedText = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .right
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))

            return attributedText

        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func convertHtmlToString() -> NSMutableAttributedString {
        let htmlData = NSString(string: self).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        do {
            let attributedString = try NSMutableAttributedString(data: htmlData ?? Data(),
                                                                 options: options,
                                                                 documentAttributes: nil)

            return attributedString

        } catch let error {
            print(error.localizedDescription)

            return NSMutableAttributedString()
        }
    }

    var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = [
            "٠": "0",
            "١": "1",
            "٢": "2",
            "٣": "3",
            "٤": "4",
            "٥": "5",
            "٦": "6",
            "٧": "7",
            "٨": "8",
            "٩": "9",
            "م": "pm",
            "ص": "am",
        ]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }

    var replacedEnglishDigitsWithArabic: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9",
                   "م": "am",
                   "ص": "pm",
        ]
        map.forEach { str = str.replacingOccurrences(of: $1, with: $0) }
        return str
    }

    func getAttributedString<T>(_ key: NSAttributedString.Key, value: T) -> NSAttributedString {
        let applyAttribute = [key: T.self]
        let attrString = NSAttributedString(string: self, attributes: applyAttribute)
        return attrString
    }

    var floatValue: Float {
        return (self as NSString).floatValue
    }

    var addAppCurrency: String {
        return self + " " + (defult.shared.getData(forKey: .appCurrency) ?? "")
    }

    var stringToDate: Date {
        let dateFormatter = DateFormatter()
        if Language.isArabic() {
            dateFormatter.locale = Locale(identifier: "ar")
        } else {
            dateFormatter.locale = Locale(identifier: "en")
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var timeStringToDate: Date {
        let dateFormatter = DateFormatter()
        if Language.isArabic() {
            dateFormatter.locale = Locale(identifier: "ar")
        } else {
            dateFormatter.locale = Locale(identifier: "en")
        }
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.date(from: self) ?? Date()
        //.replacedArabicDigitsWithEnglish
    }

    func isRequired(fontSize: CGFloat? = 10, fontName: AppFont? = .Demi) -> NSMutableAttributedString {
        let font = UIFont(name: fontName!.rawValue, size: fontSize!)!

        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appColor(.MainFontColor)!,
            .font: font,
        ]

        let secondAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .font: font,
        ]

        let firstString = NSMutableAttributedString(string: self, attributes: firstAttributes)
        let secondString = NSAttributedString(string: "  *", attributes: secondAttributes)

        firstString.append(secondString)

        return firstString
    }
}

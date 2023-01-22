//
//  Language.swift
//  Veterinary
//
//  Created by Mohammed Abouarab on 1111/2022.
//

import Foundation
import UIKit

struct Language {
    
    enum Languages {
        static let en = "en"
        static let ar = "ar"
    }
    
    static func currentLanguage() -> String {
        let langs = UserDefaults.standard.object(forKey: "AppleLanguages") as! NSArray
        let firstLang = langs.firstObject as! String
        return firstLang
    }
    static func apiLanguage() -> String {
        return self.currentLanguage().contains(Languages.ar) ? Languages.ar : Languages.en
    }
    static func setAppLanguage(lang: String) {
        UserDefaults.standard.set([lang, currentLanguage()], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        handleViewDirection()
        updateAppGroupLanguage()
    }
    static func isArabic() -> Bool {
        return self.currentLanguage().contains(Languages.ar) ? true : false
    }
    static func handleViewDirection() {
        UIPageControl.appearance().semanticContentAttribute = isArabic() ? .forceRightToLeft : .forceLeftToRight
        UIStackView.appearance().semanticContentAttribute = isArabic() ? .forceRightToLeft : .forceLeftToRight
        UISwitch.appearance().semanticContentAttribute = isArabic() ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = isArabic() ? .forceRightToLeft : .forceLeftToRight
        UICollectionView.appearance().semanticContentAttribute = isArabic() ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = isArabic() ? .right : .left
        UITextView.appearance().textAlignment = isArabic() ? .right : .left
    }
    static func updateAppGroupLanguage() {
        if let userDefaults = UserDefaults(suiteName: AppDelegate.appGroupKey) {
            userDefaults.setValue(currentLanguage(), forKey: "AppleLanguages")
            userDefaults.synchronize()
        }
    }
}

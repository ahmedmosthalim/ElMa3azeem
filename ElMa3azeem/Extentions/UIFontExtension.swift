//
//  UIFontExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    // MARK: - Enum

    private enum FontNames {
        case light
        case normal
        case bold

        var name: String {
            //            let lightNameAr = "Cairo-Light"
            //            let normalNameAr = "Cairo-Regular"
            //            let boldNameAr = "Cairo-Bold"
            //            let lightNameEn = "Cairo-Light"
            //            let normalNameEn = "Cairo-Regular"
            //            let boldNameEn = "Cairo-Bold"

            //            switch self {
            //            case .light:
            //                return Language.isArabic() ? lightNameAr : lightNameEn
            //            case .normal:
            //                return Language.isArabic() ? normalNameAr : normalNameEn
            //            case .bold:
            //                return Language.isArabic() ? boldNameAr : boldNameEn
            //            }

            let lightName = "URWDINArabic-Regular"
            let normalName = "URWDINArabic-Medium"
            let boldName = "URWDINArabic-Demi"

            switch self {
            case .light:
                return lightName
            case .normal:
                return normalName
            case .bold:
                return boldName
            }
        }
    }

    // MARK: - Objc Methods

    @objc class func myLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.light.name, size: size)!
    }

    @objc class func myRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.normal.name, size: size)!
    }

    @objc class func myBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.bold.name, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }

        var fontName = ""
        switch fontAttribute {
        case "UIFontWeightRegular":
            fontName = FontNames.light.name
        case "UIFontWeightMediam":
            fontName = FontNames.normal.name
        case "UIFontWeightSemibold", "UIFontWeightRegular":
            fontName = FontNames.bold.name
        default:
            fontName = FontNames.normal.name
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    // MARK: - Initilization

    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))), let mySystemFontMethod = class_getClassMethod(self, #selector(myRegularFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))), let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))), let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myLightFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
        // Trick to get over the lack of UIFont.init(coder:))
    }
}

/*
 "URWDINArabic-Light",
 "URWDINArabic-Regular",
 "URWDINArabic-Medium",
 "URWDINArabic-Demi",
 "URWDINArabic-Bold",
 "URWDINArabic-Black"
 */

public func printAppFont() {
    UIFont.familyNames.forEach({ familyName in
        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        print(familyName, fontNames)
    })
}


enum AppFont : String {
    case Light = "URWDINArabic-Light"
    case Regular = "URWDINArabic-Regular"
    case Medium = "URWDINArabic-Medium"
    case Demi = "URWDINArabic-Demi"
    case Bold = "URWDINArabic-Bold"
    case Black = "URWDINArabic-Black"
}

extension UILabel {
    @objc var substituteFontName: String {
        get {
            return font.fontName
        }
        set {
            let fontNameToTest = font.fontName.lowercased()
            var fontName = newValue

            if fontNameToTest.range(of: "black") != nil {
                fontName += "-Black"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "semibold") != nil {
                fontName += "-Demi"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else {
                fontName += "-Regular"
            }

            font = UIFont(name: fontName, size: font.pointSize)
        }
    }
}

extension UITextView {
    @objc var substituteFontName: String {
        get {
            return font?.fontName ?? ""
        }
        set {
            let fontNameToTest = font?.fontName.lowercased() ?? ""
            var fontName = newValue

            if fontNameToTest.range(of: "black") != nil {
                fontName += "-Black"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "semibold") != nil {
                fontName += "-Demi"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            } else {
                fontName += "-Demi"
            }

            font = UIFont(name: fontName, size: font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    @objc var substituteFontName: String {
        get {
            return font?.fontName ?? ""
        }
        set {
            let fontNameToTest = font?.fontName.lowercased() ?? ""
            var fontName = newValue

            if fontNameToTest.range(of: "black") != nil {
                fontName += "-Black"
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "semibold") != nil {
                fontName += "-Demi"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular"
            } else {
                fontName += "-Demi"
            }

            font = UIFont(name: fontName, size: font?.pointSize ?? 17)
        }
    }
}

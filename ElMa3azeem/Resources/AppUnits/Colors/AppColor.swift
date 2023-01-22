//
//  UITableViewExtension.swift
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/9/21.
//  Copyright © 2022 Abdullah Tarek & Ahmed Mostafa Halim. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI

enum AssetsColor: String {
    case MainColor
    case MainFontColor
    case SecondFontColor
    case BorderColor
    case BackGroundColor
    case StoreStateOpen
    case StoreStateClose
    case myMessageChatColor
    case otherMessageChatColor
    case viewBackGround
    case SecondViewBackGround
    case placeHolderColor
    case SecondaryMainColor
    case viewBackGround80
    case stepLineColor
    case AppTextFieldPlaceHolder
    case BackGroundCell
    case mainColorWithAlpha
}

extension UIColor {
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

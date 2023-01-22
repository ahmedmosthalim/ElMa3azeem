//
//  localizeStringExtension.swift
//  shop and buy
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import Foundation
import UIKit
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    enum localizeAdditions {
        case allUpperCase
        case allLowerCase
        case firstCapital
        case wordAfter(string: String)
        case wordBefore(string: String)
    }

    func localizedWith(addition: localizeAdditions) -> String {
        var word: String = NSLocalizedString(self, comment: "")

        switch addition {
        case .allUpperCase:
            word = word.uppercased()
        case .allLowerCase:
            word = word.lowercased()
        case .firstCapital:
            word = word.startcased()
        case let .wordAfter(string):
            word = word + " " + string
        case let .wordBefore(string):
            word = string + " " + word
        }

        return word
    }
}

extension StringProtocol {
    func startcased() -> String {
        components(separatedBy: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}

public extension UILabel {
    @IBInspectable var localizeKey: String? {
        get {
            return text
        }
        set {
            text = NSLocalizedString(newValue ?? "", comment: "")
        }
    }
}

public extension UIButton {
    @IBInspectable var localizeKey: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle(NSLocalizedString(newValue ?? "", comment: ""), for: .normal)
        }
    }
}

public extension UITextField {
    @IBInspectable var localizeKey: String? {
        get {
            return placeholder
        }
        set {
            placeholder = NSLocalizedString(newValue ?? "", comment: "")
        }
    }
}

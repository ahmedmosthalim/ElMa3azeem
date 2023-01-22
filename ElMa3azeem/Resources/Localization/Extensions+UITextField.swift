//
//  Extensions+UITextField.swift
//  Veterinary
//
//  Created by Mohammed Abouarab on 1111/2022.
//

import UIKit

//MARK:- Localization
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if Language.isArabic() {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        } else {
            if textAlignment == .natural {
                self.textAlignment = .left
            }
        }
    }
}




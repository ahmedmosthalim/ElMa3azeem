//
//  Extensions+UICollectionView.swift
//  Veterinary
//
//  Created by Mohammed Abouarab on 1111/2022.
//

import UIKit

extension UICollectionViewFlowLayout {
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return Language.isArabic() ? true : false
    }
}


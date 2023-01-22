//
//  UIstackViewExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2911/2022.
//

import Foundation
import UIKit

extension UIStackView {
    func reloadData(animationDirection:AnimationDirection) {
        self.layoutIfNeeded()
        let subViews = self.arrangedSubviews
        var index = 0
        let stackHeight: CGFloat = self.bounds.size.height
        for i in subViews {
            let view: UIView = i as UIView
            switch animationDirection {
            case .up:
                view.transform = CGAffineTransform(translationX: 0, y: -stackHeight)
                break
            case .down:
                view.transform = CGAffineTransform(translationX: 0, y: stackHeight)
                break
            case .left:
                view.transform = CGAffineTransform(translationX: stackHeight, y: 0)
                break
            case .right:
                view.transform = CGAffineTransform(translationX: -stackHeight, y: 0)
                break
            }
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
}

public enum AnimationDirection {
    case up
    case down
    case left
    case right
}

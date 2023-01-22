//
//  UITableViewExtension.swift
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/9/21.
//  Copyright © 2022 Abdullah Tarek & Ahmed Mostafa Halim. All rights reserved.
//

import UIKit
import Foundation


public extension UITableView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UITableViewCell.Type
     - Parameter identifier: String?
     */
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell
     - Parameter type: UITableViewCell.Type
     */
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell and IndexPath
     - Parameter type: UITableViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func reloadWithAnimation() {
        let animationDirection = AnimationDirection.down
        self.reloadData()
        let cells = self.visibleCells
        var index = 0
        let tableViewHeight = self.bounds.size.height
        for i in cells {
            let view: UIView = i as UIView
            switch animationDirection {
            case .up:
                view.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
                break
            case .down:
                view.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
                break
            case .left:
                view.transform = CGAffineTransform(translationX: tableViewHeight, y: 0)
                break
            case .right:
                view.transform = CGAffineTransform(translationX: -tableViewHeight, y: 0)
                break
            }
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
}

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

//for dynamic hight
class IntrinsicTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}

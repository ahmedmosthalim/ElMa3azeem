//
//  CustomViews.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import Foundation
import UIKit

class BottomView: UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .appColor(.viewBackGround)
        switch UIDevice().type {
        case .iPhoneSE, .iPhoneSE2, .iPhone6, .iPhone6Plus, .iPhone6S, .iPhone6SPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus:
            isHidden = true
        default:
            isHidden = false
        }
    }
}

class AppTextFieldViewStyle: UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if backgroundColor == .appColor(.SecondViewBackGround) {
            backgroundColor = .appColor(.AppTextFieldPlaceHolder)
            
        }else{
            backgroundColor = .appColor(.AppTextFieldPlaceHolder)
        }
        layer.cornerRadius = 10
    }
}

class NotificationView: UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateNotificationCount()
    }

    func updateNotificationCount() {
        if defult.shared.getDataInt(forKey: .unSeenNorificationCount) == 0 {
            isHidden = true
        } else {
            isHidden = false
        }
    }
}

class NavigationView: UIView {
    @IBInspectable
    var appBackgroundColor: UIColor? {
        get {
            if let color = backgroundColor {
                return color
            }
            return nil
        }
        
        set {
            if let color = newValue {
                backgroundColor = color
            } else {
                backgroundColor = nil
            }
        }
    }

    // init
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if appBackgroundColor != nil {
            backgroundColor = appBackgroundColor
            print(appBackgroundColor!)
        }
    }
}

class RectangularDashedView: UIView {
    
    @IBInspectable var cornerRadiuss: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadiuss
            layer.masksToBounds = cornerRadiuss > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadiuss > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiuss).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

//
//  CustomButtons.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import Foundation
import UIKit

enum ButtonState {
    case select
    case notSelect
}

class MainButton: UIButton {
    required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = .appColor(.MainColor)
        layer.cornerRadius = 10
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.appColor(.MainColor)?.cgColor
        setTitleColor(.appColor(.MainFontColor), for: .normal)
        UIFont.systemFont(ofSize: 14.0)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .appColor(.MainColor)
        layer.cornerRadius = 10
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.appColor(.MainColor)?.cgColor
    }
}

public class UnderLineButton: UIButton {
    let bottomLine = CALayer()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 2)
        layer.addSublayer(bottomLine)
    }

    func selectButton() {
        UIView.animate(withDuration: 0.2) {
            self.bottomLine.backgroundColor = UIColor.appColor(.MainColor)?.cgColor
            self.setTitleColor(.appColor(.MainColor), for: .normal)
        }
    }

    func notSelectButton() {
        UIView.animate(withDuration: 0.2) {
            self.bottomLine.backgroundColor = UIColor.clear.cgColor
            self.setTitleColor(.appColor(.SecondFontColor), for: .normal)
        }
    }
}

public class RoundedButton: UIButton {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
        backgroundColor = .appColor(.MainColor)
        setTitleColor(.white, for: .normal)
    }

    func selectButton() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .appColor(.MainColor)
            self.setTitleColor(.white, for: .normal)
        }
    }

    func notSelectButton() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .clear
            self.setTitleColor(.appColor(.placeHolderColor), for: .normal)
//            self.setTitleColor(., for: .normal)
        }
    }
}

@IBDesignable
class GradientView: UIView {
    var first: UIColor = .white
    var last: UIColor = .black

    @IBInspectable var firistColor: UIColor {
        get {
            return first
        }
        set {
            first = newValue
        }
    }

    @IBInspectable var lastColor: UIColor {
        get {
            return last
        }
        set {
            last = newValue
        }
    }

    @IBInspectable var isHorizontal: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10
    }

    required init() {
        super.init(frame: .zero)
        layer.cornerRadius = 10
    }

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        createGraidView()
    }

    func createGraidView() {
        let gradientLayer = layer as! CAGradientLayer
        if isHorizontal == true {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        print("createGraidView")
        gradientLayer.colors = [
            first.cgColor,
            last.cgColor,
        ]
        
        gradientLayer.cornerRadius = 10
    }
}

@IBDesignable class SpaceingImageButton: MainButton {
    @IBInspectable var spacing: CGFloat = 0 {
        didSet {
            let insetAmount = spacing / 2
            let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
            if isRTL {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
                contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
                contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
    }
    
    required init(title: String) {
        fatalError("init(title:) has not been implemented")
    }
}


extension UIView {
    func addBlurEffect(style: UIBlurEffect.Style, sendToBack: Bool = false) {
        let bounds = self.bounds
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(visualEffectView)
        if sendToBack {
            sendSubviewToBack(visualEffectView)
        }
    }
}

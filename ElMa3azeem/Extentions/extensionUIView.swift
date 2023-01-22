//
//  extensionUIView.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation
import UIKit

extension UIView {
    func flipX() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    
    func appStypeTextField() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.appColor(.BorderColor)?.cgColor
        layer.borderWidth = 1
        backgroundColor = UIColor(hexString: "#202020")
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func createDashedLine(color: UIColor) {
        let point1 = CGPoint(x: bounds.minX, y: bounds.minY)
        let point2 = CGPoint(x: bounds.maxX, y: bounds.minY)
        let width: CGFloat = 2
        
        let strokeLength: NSNumber = 5
        let gapLength: NSNumber = 3
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func removeDashLine() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func setupChatBootStyleEnglish() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner,
        ]
    }
    
    func setupChatBootStyleArabic() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
        ]
    }
    
    func addDashedBorder() {
        let color = UIColor.appColor(.MainColor)?.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        layer.addSublayer(shapeLayer)
    }
    
    func addTapGesture(numberOfTapsRequired: Int = 1, _ action: @escaping () -> Void) {
        endEditing(true)
        isUserInteractionEnabled = true
        
        let tap = MyTapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let p = tap.location(in: self)
        print("🙄p \(p)")
        tap.action = action
        tap.numberOfTapsRequired = numberOfTapsRequired
        addGestureRecognizer(tap)
        
        endEditing(true)
    }
    
    class MyTapGestureRecognizer: UITapGestureRecognizer {
        var action: (() -> Void)?
    }
    
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        alpha = 0.2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: { self.alpha = 1.0 }, completion: nil)
        sender.action!()
    }
    
    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

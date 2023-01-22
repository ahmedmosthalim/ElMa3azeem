//
//  extensionUIImageView.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func makeCircularPhoto(borderWidth width:CGFloat = 0.5 , borderColor color:UIColor = .gray) {
        self.layer.borderWidth = width
        self.layer.masksToBounds = false
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    func makeRadiusImageView(borderWidth width:CGFloat , borderColor color:UIColor , cornerRadius radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    func setImage(image:String , loading:Bool? = true) {
        if loading == true {
            self.kf.indicatorType = .activity
        }
        self.kf.setImage(with: URL(string: image),
                         options: [.scaleFactor(UIScreen.main.scale),
                                   .transition(.none),
                                   .cacheOriginalImage],
                         progressBlock: nil) { (result) in
            
            switch result {
            case .success(_):
                print("image load successed")
            case .failure(let error):
                self.image = UIImage(named: "logo")
                print("\(error.localizedDescription)")
            }
        }
    }
}

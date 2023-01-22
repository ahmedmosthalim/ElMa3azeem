//
//  File.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Foundation
import UIKit

class UserMarkerIconView: UIView {

    //MARK:- Properities
    let theFrame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 80) //the frame for all views (it is equal to the normal size of the images)
    var image: String!
    
    //MARK:- initializer
    init(image: String) {
        super.init(frame: theFrame)
        self.image = image
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Design Methods
    private func setupViews() {
        
        //ImageView design
        
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.frame = theFrame
        imageView.contentMode = .scaleAspectFit
        
        //add th views to the superview (self)
        self.addSubview(imageView)
        
        //add the constraint
        imageView.center = self.center
    }
}

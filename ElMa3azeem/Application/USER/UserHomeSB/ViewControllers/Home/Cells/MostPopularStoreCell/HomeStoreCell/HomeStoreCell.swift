//
//  HomeStoreCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//  Copyright © 2022 Abdullah Tarek & Ahmed Mostafa Halim. All rights reserved.
//

import UIKit

class HomeStoreCell: UICollectionViewCell , StoreSliderCellView{

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellStoreName: UILabel!
    @IBOutlet weak var cellCategory: UILabel!
    @IBOutlet weak var cellRate: UILabel!
    @IBOutlet weak var cellDistance: UILabel!
    
    @IBOutlet weak var stateview: UIView!
    @IBOutlet weak var stateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shadowDecorate()
        
        // Initialization code
    }
    
    func setImage(url: String) {
        cellImage.setImage(image: url, loading: true)
    }
    
    func setStoreName(name: String) {
        cellStoreName.text = name
    }
    
    func setStoreCategory(category: String) {
        cellCategory.text = category
    }
    
    func setDistance(dist: String) {
        cellDistance.text = dist
    }
    
    func setRate(rate: String) {
        cellRate.text = rate
    }
    
    func storeState(state: Bool) {
        if state == true {
            stateview.backgroundColor = UIColor.appColor(.StoreStateOpen)
            stateLbl.text = "Open".localized
        }else{
            stateview.backgroundColor = UIColor.appColor(.StoreStateClose)
            stateLbl.text = "Closed".localized
        }
    }
}


extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.10
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}

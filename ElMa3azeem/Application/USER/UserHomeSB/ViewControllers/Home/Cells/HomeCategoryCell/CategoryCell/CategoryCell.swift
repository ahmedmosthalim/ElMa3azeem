//
//  CategoryCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 28/11/2022.
//

import UIKit

class CategoryCell: UICollectionViewCell , CategoryCellView{
    func setImage(url: String) {
        CellImage.setImage(image: url)
    }
    
    func setTitle(name: String) {
        cellTitle.text = name
    }
    

    @IBOutlet weak var CellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    var selectCategory : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let maskedView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        maskedView.backgroundColor = .black.withAlphaComponent(0.5)
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = maskedView.bounds
        
        maskedView.clipsToBounds = true
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0.0, 0.4]
        
        maskedView.layer.mask = gradientMaskLayer
        CellImage.addSubview(maskedView)
        
        // Initialization code
    }
    @IBAction func selectCategoryAction(_ sender: Any) {
        selectCategory?()
    }
    
}

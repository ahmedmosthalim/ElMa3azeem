//
//  ProductAddSeletedSingleFeatureCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import UIKit

class ProductAddSeletedSingleFeatureCell: UICollectionViewCell {

    @IBOutlet weak var featureLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(item : Properity){
        featureLbl.text = item.name ?? ""
    }
}

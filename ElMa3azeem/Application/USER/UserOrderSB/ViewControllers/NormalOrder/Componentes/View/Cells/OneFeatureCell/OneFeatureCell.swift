//
//  OneFeatureCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1411/2022.
//

import UIKit

class OneFeatureCell: UICollectionViewCell {

    @IBOutlet weak var ckeckBox: UIImageView!
    @IBOutlet weak var featureLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(feature : Properity? , current : Int) {
        featureLbl.text = feature?.name
        
        if feature?.id == current {
            ckeckBox.image = UIImage(named: "circle_check_Mark_selected")
        }else{
            ckeckBox.image = UIImage(named: "circle_check_Mark_not_selected")
        }
        
    }
}

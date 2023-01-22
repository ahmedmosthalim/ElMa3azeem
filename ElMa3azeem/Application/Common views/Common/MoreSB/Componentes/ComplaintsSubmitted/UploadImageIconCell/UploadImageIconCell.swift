//
//  UploadImageIconCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class UploadImageIconCell: UICollectionViewCell {

    @IBOutlet weak var bg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bg.addDashedBorder()
        
    }


}

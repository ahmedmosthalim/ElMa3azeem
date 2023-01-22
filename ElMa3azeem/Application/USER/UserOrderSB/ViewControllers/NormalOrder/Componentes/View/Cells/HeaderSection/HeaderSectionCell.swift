//
//  HeaderSectionCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1111/2022.
//

import UIKit

class HeaderSectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackGround: UIView!
    @IBOutlet weak var cellTitile: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(title : String) {
        cellTitile.text = title
    }
}

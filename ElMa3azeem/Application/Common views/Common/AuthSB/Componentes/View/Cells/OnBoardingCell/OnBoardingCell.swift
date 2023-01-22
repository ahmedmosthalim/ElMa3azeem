//
//  OnBoardingCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCellImage(url: String) {
        cellImage.setImage(image: url, loading: true)
    }
    
    func setCellTitle(title: String) {
        cellTitle.text = title
    }
    
    func setCellDescirotion(text: String) {
        cellDescription.text = text
    }
}

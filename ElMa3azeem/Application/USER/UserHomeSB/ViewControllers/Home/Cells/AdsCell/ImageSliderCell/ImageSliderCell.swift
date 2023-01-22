//
//  ImageSliderCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import UIKit

class ImageSliderCell: UICollectionViewCell , ImageSliderCellView {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setImage(url: String) {
        cellImage.setImage(image: url, loading: true)
    }
    
    func setIcon(url: String) {
        cellIcon.setImage(image: url, loading: true)
    }
    
    func setTitle(name: String) {
        cellTitle.text = name
    }
    
    func setDescription(desc: String) {
        cellDescription.text = desc
    }
}

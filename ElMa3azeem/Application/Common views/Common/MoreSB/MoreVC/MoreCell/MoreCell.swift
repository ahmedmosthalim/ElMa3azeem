//
//  MoreCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class MoreCell: UITableViewCell , MoreCellView{
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    func setImage(imageName: String) {
        cellImage.image = UIImage(named: imageName)
    }
    
    func setTitle(title: String) {
        cellTitle.text = title
    }
    
}

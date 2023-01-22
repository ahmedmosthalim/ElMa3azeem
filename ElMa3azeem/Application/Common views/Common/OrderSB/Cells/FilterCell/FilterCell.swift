//
//  FilterCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 31/11/2022.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configCell(item : FilterModel) {
        cellTitle.text = item.title.localized
        cellImage.image = item.isSelected ? UIImage(named: "circle-mark-selected") : UIImage(named: "circle-mark-not-selected")
        cellTitle.textColor = item.isSelected ? UIColor.appColor(.MainColor) : UIColor.appColor(.MainFontColor)
    }
}

struct FilterModel {
    var title : String
    var key : FilterStores
    var isSelected : Bool
}

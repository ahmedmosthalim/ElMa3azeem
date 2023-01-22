//
//  AdditionsCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1511/2022.
//

import UIKit

class AdditionsCell: UITableViewCell {

    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configCell(product : ProductAdditive) {
        titleLbl.text = product.name
        priceLbl.text = product.price?.addAppCurrency
        if product.isSelected == false || product.isSelected == nil {
            checkBox.image = UIImage(named:"squar_check_mark_not_selected")
        }else{
            checkBox.image = UIImage(named:"squar_check_mark_selected")
        }
    }
}
